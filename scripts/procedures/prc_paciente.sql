-- --------- Legenda ------------
-- p = parametro
-- v = variavel
-- ------------------------------

DELIMITER $$

CREATE PROCEDURE prc_buscar_paciente_completo(
    IN p_id_paciente INT,
    OUT p_mensagem JSON
) BEGIN

    -- PACIENTE
    DECLARE v_nome VARCHAR(150);
    DECLARE v_foto VARCHAR(255);
    DECLARE v_data_nascimento DATE;
    DECLARE v_cpf VARCHAR(20);
    DECLARE v_serie_escolar VARCHAR(30);
    DECLARE v_grau_suporte VARCHAR(30);

    -- JSONS
    DECLARE v_diagnostico 	JSON;
    DECLARE v_habilidades 	JSON;
    DECLARE v_psicopedagogo JSON;
    DECLARE v_responsaveis 	JSON;
    
    DECLARE data_hoje DATE;
    SET data_hoje = curdate();

    -- VALIDAÇÃO
    IF NOT EXISTS (
        SELECT 1 FROM tb_paciente WHERE id = p_id_paciente
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSE

        -- PACIENTE
        SELECT nome, foto, data_nascimento, cpf, serie, grau
        INTO v_nome, v_foto, v_data_nascimento, v_cpf, v_serie_escolar, v_grau_suporte
        FROM vw_data_paciente WHERE id_paciente = p_id_paciente;

		-- DIAGNÓSTICO
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'sigla', 			diagnostico.sigla,
                'id_transtorno', 	diagnostico.id_diagnostico,
                'nome_completo', 	diagnostico.nome_completo
            )
        )
        INTO v_diagnostico
        FROM vw_diagnostico_paciente diagnostico
        WHERE id_paciente = p_id_paciente;
        
        SET v_diagnostico = IFNULL(v_diagnostico, JSON_ARRAY());

        -- HABILIDADES
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', 			habilidade_paciente.id_habilidade,
                'nome', 		habilidade_paciente.nome_habilidade,
                'idade_meses', 	habilidade_paciente.idade_meses
            )
        )
        INTO v_habilidades 
        FROM vw_habilidades_paciente habilidade_paciente
        WHERE id_paciente = p_id_paciente;

        SET v_habilidades = IFNULL(v_habilidades, JSON_ARRAY());

        -- RESPONSÁVEIS
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', 		responsavel.id_usuario,
                'nome', 	responsavel.nome,
                'telefone', responsavel.telefone
            )
        )
        INTO v_responsaveis
        FROM vw_responsavel_paciente responsavel
        WHERE id_paciente = p_id_paciente;

        SET v_responsaveis = IFNULL(v_responsaveis, JSON_ARRAY());

		-- PSICOPEDAGOGO
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', 		psicopedagogo.id_usuario,
                'nome', 	psicopedagogo.nome,
                'telefone', psicopedagogo.telefone
            )
        )
        INTO v_psicopedagogo
        FROM vw_psicopedagogo_paciente psicopedagogo
        WHERE id_paciente = p_id_paciente;

        SET v_psicopedagogo = IFNULL(v_psicopedagogo, JSON_ARRAY());

        -- RETORNO FINAL
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', '200',
            'message', 'Paciente encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', JSON_OBJECT(
                'id', p_id_paciente,
                'foto', v_foto,
                'nome', v_nome,
                'data_nascimento', DATE_FORMAT(v_data_nascimento, '%d/%m/%Y'),
                'idade', TIMESTAMPDIFF(YEAR, v_data_nascimento, CURDATE()),
                'cpf', v_cpf,
                'grau_suporte', v_grau_suporte,
                'serie_escolar', v_serie_escolar,
                'grafico', v_habilidades,
                'diagnostico', v_diagnostico,
				'psicopedagogo', v_psicopedagogo,
                'responsavel', v_responsaveis
            )
        );

    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_adicionar_paciente(
    IN p_foto VARCHAR(255),
	IN p_nome VARCHAR(150),
    IN p_diagnostico VARCHAR(400),
    IN p_cpf VARCHAR(20),
    IN p_data_nascimento DATE,
    IN p_id_serie_escolar INT,
    IN p_id_grau_suporte INT,
    IN p_id_responsavel INT,
    OUT p_mensagem JSON
) BEGIN

	DECLARE novo_id INT;
	DECLARE data_hoje DATE;
    SET data_hoje = curdate();


    -- valida duplicidade
    IF EXISTS (
        SELECT 1 FROM tb_paciente WHERE cpf = p_cpf
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Dados de inserção foram encontrados já cadastrados!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_serie_escolar WHERE id = p_id_serie_escolar) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'Não foi possível processar a requisição pois existem campos obrigatórios que devem ser encaminhados, e atendidos conforme documentação!!! [ID SÉRIE ESCOLAR]',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_grau_suporte WHERE id = p_id_grau_suporte) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'Não foi possível processar a requisição pois existem campos obrigatórios que devem ser encaminhados, e atendidos conforme documentação!!! [ID GRAU DE SUPORTE]',
            'data', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id_responsavel) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'Não foi possível processar a requisição pois existem campos obrigatórios que devem ser encaminhados, e atendidos conforme documentação!!! [ID RESPONSAVEL]',
            'data', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_responsavel AND id_tipo_usuario = 2) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 401,
            'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
            'data', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    ELSE

        -- insert paciente
        INSERT INTO tb_paciente(
            foto,
            nome,
            cpf,
            data_nascimento,
            id_serie_escolar,
            id_grau_suporte,
            id_usuario
        )
        VALUES (
            p_foto,
            p_nome,
            p_cpf,
            p_data_nascimento,
            p_id_serie_escolar,
            p_id_grau_suporte,
            p_id_responsavel
        );

        SET novo_id = LAST_INSERT_ID();

        -- vínculo responsável
        INSERT INTO tb_usuario_paciente(id_usuario, id_paciente)
        VALUES (p_id_responsavel, novo_id);

        INSERT INTO tb_paciente_transtorno (id_paciente, id_sigla_transtorno)
        SELECT novo_id, v_id_transtorno
        FROM JSON_TABLE(
			p_diagnostico,
            '$[*]' COLUMNS (
				v_id_transtorno INT PATH '$'
            )
        ) AS lista_transtornos;

		
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Item criado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_buscar_paciente_completo(novo_id, @resultPaciente);

    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualizar_paciente(

	IN p_id_usuario INT,
	IN p_id_paciente INT,
	IN p_nome VARCHAR(150),
    IN p_foto VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_diagnostico VARCHAR(400),
    IN p_cpf VARCHAR(20),
    IN p_id_serie_escolar INT,
    IN p_id_grau_suporte INT,
    OUT p_mensagem JSON
    
) BEGIN
    
	DECLARE data_hoje DATE;
    SET data_hoje = curdate();
    
    IF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id_usuario) THEN 
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Não foram encontrados, dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
        
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 2) THEN
    
		SET p_mensagem = JSON_OBJECT(
			'status', TRUE,
			'status_code', 401,
			'message', 'Não autorizado',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
		
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario_paciente WHERE id_paciente = p_id_paciente AND id_usuario = p_id_usuario) THEN
    
		SET p_mensagem = JSON_OBJECT(
			'status', TRUE,
			'status_code', 401,
			'message', 'Não autorizado',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Não foram encontrados, dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    ELSEIF EXISTS (SELECT 1 FROM tb_paciente WHERE cpf = p_cpf AND id != p_id_paciente) THEN
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Dados de inserção foram encontrados já cadastrados!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_serie_escolar WHERE id = p_id_serie_escolar) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_serie_esolar Incorreto',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_grau_suporte WHERE id = p_id_grau_suporte) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_grau_suporte Incorreto',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
    ELSE
		
        -- atualiza o paciente
        UPDATE tb_paciente SET
			nome = p_nome,
            foto = p_foto,
            cpf = p_cpf,
            data_nascimento = p_data_nascimento,
            id_serie_escolar = p_id_serie_escolar,
            id_grau_suporte = p_id_grau_suporte
		WHERE id = p_id_paciente;
    
		INSERT INTO tb_paciente_transtorno (id_paciente, id_sigla_transtorno)
        SELECT p_id_paciente, v_id_transtorno
        FROM JSON_TABLE(
			p_diagnostico,
            '$[*]' COLUMNS (
				v_id_transtorno INT PATH '$'
            )
        ) AS lista_transtornos;
    
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
			'status_code', 200,
            'message', 'Item atualizado com sucesso'
        );
        
        CALL prc_buscar_paciente_completo(p_id_paciente, @resultPaciente);
        
	END IF;
    
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE proc_delete_paciente(
	IN p_id_usuario INT,
	IN p_id_paciente INT,
    OUT p_mensagem JSON
) BEGIN
	
	DECLARE data_hoje DATE;
    SET data_hoje = curdate();
    
    -- valida se o paciente existe
    IF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
	
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
	
    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = p_id_paciente) THEN
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    ELSE
		
        IF  EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 2) THEN
        
			DELETE FROM tb_usuario_paciente 	WHERE id_paciente = p_id_paciente;
			DELETE FROM tb_paciente_habilidade	WHERE id_paciente = p_id_paciente;
			DELETE FROM tb_paciente_transtorno 	WHERE id_paciente = p_id_paciente;
			DELETE FROM tb_formulario			WHERE id_paciente = p_id_paciente;
			DELETE FROM tb_atividade			WHERE id_paciente = p_id_paciente;
            DELETE FROM tb_paciente				WHERE id = p_id_paciente;
        
			SET p_mensagem = JSON_OBJECT(
				'status', TRUE,
				'status_code', 200,
				'message', 'Delete realizado com sucesso',
				'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
            );
        
        ELSEIF EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN
			
			DELETE FROM tb_usuario_paciente WHERE id_paciente = p_id_paciente AND id_usuario = p_id_usuario;
        
			SET p_mensagem = JSON_OBJECT(
				'status', TRUE,
				'status_code', 200,
				'message', 'Delete realizado com sucesso',
				'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
            );
        
        ELSE
        
			SET p_mensagem = JSON_OBJECT(
				'status', TRUE,
				'status_code', 401,
				'message', 'Não autorizado',
				'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
            );
        
		END IF;
    
    END IF;
    
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_inserir_relacao_usuario_paciente(
    IN p_id_paciente INT,
    IN p_id_usuario INT,
    OUT p_mensagem JSON
) BEGIN

	DECLARE data_hoje DATE;
    SET data_hoje = curdate();

    -- valida paciente
    IF NOT EXISTS (
        SELECT 1 FROM tb_paciente WHERE id = p_id_paciente
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    -- valida psicopedagogo
    ELSEIF NOT EXISTS (
        SELECT 1 FROM tb_usuario WHERE id = p_id_usuario
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Usuário não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF EXISTS (
        SELECT 1 
        FROM tb_usuario_paciente 
        WHERE id_paciente = p_id_paciente 
          AND id_usuario = p_id_usuario
    ) THEN
    
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Essa relação já existe',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSE

        INSERT INTO tb_usuario_paciente (id_usuario, id_paciente) VALUES (p_id_usuario, p_id_paciente);

        -- sobrescreve mensagem
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Item criado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_buscar_paciente_completo(p_id_paciente, @resultPaciente);

    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_retorna_paciente_pelo_cpf(

	IN p_cpf VARCHAR(20),
    OUT p_message JSON

) BEGIN
	
	DECLARE data_hoje DATE;
    SET data_hoje = curdate();

	IF NOT EXISTS(
		SELECT 1
        FROM tb_paciente
        WHERE cpf = p_cpf
    ) THEN  SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    ELSE
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

        CALL prc_buscar_paciente_completo((
            SELECT id FROM tb_paciente WHERE cpf = p_cpf
        ), @resultPaciente);
    
    END IF;

END$$

DELIMITER ;


-- @returnPacienteCpf
-- @resultPaciente
-- @resultDeletePaciente
-- @resultInsertRelation
-- @resultUpdatePaciente
-- @resultInsertPaciente