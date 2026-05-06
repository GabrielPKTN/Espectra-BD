-- ----------------------------------
-- PROCEDURES
-- ----------------------------------

------------------------------------------
-- CRIAR HABILIDADES PACIENTE
------------------------------------------

DELIMITER $$

CREATE PROCEDURE proc_cria_habilidades_paciente(
	IN p_id_paciente INT,
    OUT p_mensagem JSON
)
BEGIN

  -- valida se o paciente existe
    IF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
	
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'message', 'Paciente não encontrado'
		);
	
    ELSE
    
		INSERT INTO tb_paciente_habilidade (id_paciente, id_habilidade, anos_meses)
		SELECT p_id_paciente AS id_paciente,
		h.id,
        0.0 AS anos_meses
		FROM tb_habilidade h
        WHERE NOT EXISTS (
            SELECT 1
            FROM tb_paciente_habilidade ph
            WHERE ph.id_paciente = p_id_paciente
              AND ph.id_habilidade = h.id
        );
        
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'message', 'Habilidades inseridas com sucesso!!'
		);
        
    END IF;


END $$

DELIMITER ;


--------------------------------------------------------------------
-- BUSCA TODODS OS DADOS REFERENTE AO PACIENTE PARA RETORNAR NO JSON
---------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE prc_buscar_paciente_completo(
    IN p_id_paciente INT,
    OUT p_mensagem JSON
)
BEGIN
    -- PACIENTE
    DECLARE v_nome VARCHAR(150);
    DECLARE v_foto VARCHAR(255);
    DECLARE v_data_nascimento DATE;
    DECLARE v_idade INT;
    DECLARE v_diagnostico VARCHAR(50);
    DECLARE v_numero_registro VARCHAR(50);
    DECLARE v_grau_suporte INT;
    DECLARE v_serie_escolar VARCHAR(50);

    -- PSICOPEDAGOGO
    DECLARE v_id_psicopedagogo INT;
    DECLARE v_nome_psico VARCHAR(150);
    DECLARE v_tel_psico VARCHAR(20);

    -- JSONS
    DECLARE v_habilidades JSON;
    DECLARE v_responsaveis JSON;

    -- VALIDAÇÃO
    IF NOT EXISTS (
        SELECT 1 FROM tb_paciente WHERE id = p_id_paciente
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', '404',
            'message', 'Paciente não encontrado',
            'data', NULL
        );

    ELSE

        -- PACIENTE
        SELECT 
            p.nome,
            p.foto,
            p.data_nascimento,
            p.diagnostico,
            p.numero_registro,
            g.grau,
            s.serie,
            p.id_psicopedagogo
        INTO
            v_nome,
            v_foto,
            v_data_nascimento,
            v_diagnostico,
            v_numero_registro,
            v_grau_suporte,
            v_serie_escolar,
            v_id_psicopedagogo
        FROM tb_paciente p
        LEFT JOIN tb_grau_suporte g ON g.id = p.id_grau_suporte
        LEFT JOIN tb_serie_escolar s ON s.id = p.id_serie_escolar
        WHERE p.id = p_id_paciente
        LIMIT 1;

        -- IDADE
        SET v_idade = IFNULL(
            TIMESTAMPDIFF(YEAR, v_data_nascimento, CURDATE()),
            NULL
        );

        -- PSICOPEDAGOGO
        SELECT
            nome,
            telefone
        INTO
            v_nome_psico,
            v_tel_psico
        FROM tb_psicopedagogo
        WHERE id = v_id_psicopedagogo
        LIMIT 1;

        -- HABILIDADES
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', h.id,
                'nome', h.nome,
                'valor_meses', ph.anos_meses
            )
        )
        INTO v_habilidades
        FROM tb_paciente_habilidade ph
        JOIN tb_habilidade h ON h.id = ph.id_habilidade
        WHERE ph.id_paciente = p_id_paciente;

        SET v_habilidades = IFNULL(v_habilidades, JSON_ARRAY());

        -- RESPONSÁVEIS
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', r.id,
                'nome', r.nome,
                'telefone', r.telefone
            )
        )
        INTO v_responsaveis
        FROM tb_responsavel_paciente rp
        JOIN tb_responsavel r ON r.id = rp.id_responsavel
        WHERE rp.id_paciente = p_id_paciente;

        SET v_responsaveis = IFNULL(v_responsaveis, JSON_ARRAY());

        -- RETORNO FINAL
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', '200',
            'message', 'Paciente encontrado',
            'data', JSON_OBJECT(
                'id', p_id_paciente,
                'foto', v_foto,
                'nome', v_nome,
                'data_nascimento', v_data_nascimento,
                'idade', v_idade,
                'diagnostico', v_diagnostico,
                'numero_registro', v_numero_registro,
                'grau_suporte', v_grau_suporte,
                'serie_escolar', v_serie_escolar,
                'grafico', v_habilidades,

                'psicopedagogo', JSON_ARRAY(
                    JSON_OBJECT(
                        'id', v_id_psicopedagogo,
                        'nome', v_nome_psico,
                        'telefone', v_tel_psico
                    )
                ),

                'responsavel', v_responsaveis
            )
        );

    END IF;

END $$

DELIMITER ;



-----------------------------------------
-- ADICIONAR PSICOPEDAGOGO
-----------------------------------------

DELIMITER $$
CREATE PROCEDURE procedure_adicionar_psicopedagogo(
	IN p_foto VARCHAR(255),
    IN p_nome VARCHAR(150),
    IN p_data_nascimento DATE,
    IN p_telefone VARCHAR(20),
    IN p_email VARCHAR(255),
    IN p_senha VARCHAR(50),
    OUT p_mensagem JSON
)
BEGIN
	IF EXISTS (SELECT 1 FROM tb_psicopedagogo WHERE email = p_email) THEN
    
		SET p_mensagem = JSON_OBJECT(
			'status', false,
            'message', 'Este perfil contem dados já existentes',
            'data', NULL
        );
        
    ELSE
    
		INSERT INTO tb_psicopedagogo(foto, nome, data_nascimento, telefone, email, senha) 
			VALUES (p_foto, p_nome, p_data_nascimento, p_telefone, p_email, p_senha);
		
        SET p_mensagem = JSON_OBJECT(
			'status', true,
            'status_code', 200,
            'message', 'Psicopedagogo cadastrado com sucesso',
            'data', JSON_OBJECT(
                'nome', p_nome,
                'data_nascimento', p_data_nascimento,
                'telefone', p_telefone,
                'email', p_email,
                'senha', p_senha
            )
        );
        
	END IF;

END $$
DELIMITER ;

-- Quando a procedure for usada no Back-End deve ser chamada dessa maneira, o SELECT na mensagem já retorna um JSON com os dados cadastrados.
call procedure_adicionar_psicopedagogo('foto.png', 'Enzo Carrilho', '2005-09-25', '(11)95978-8007', 'enzo@email.com', '123456', @msg);
SELECT @msg;


-----------------------------------------
-- ADICIONAR PACIENTE
-----------------------------------------

DELIMITER $$

CREATE PROCEDURE prc_adicionar_paciente(
    IN p_nome VARCHAR(150),
    IN p_foto VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_diagnostico VARCHAR(50),
    IN p_id_serie_escolar INT,
    IN p_id_grau_suporte INT,
    IN p_id_responsavel INT,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_numero_registro VARCHAR(20);
    DECLARE novo_id INT;

    -- valida duplicidade
    IF EXISTS (
        SELECT 1 FROM tb_paciente WHERE nome = p_nome
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Este paciente já existe',
            'data', NULL
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_serie_escolar WHERE id = p_id_serie_escolar) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_serie_esolar Incorreto',
            'data', NULL
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_grau_suporte WHERE id = p_id_grau_suporte) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_grau_suporte Incorreto',
            'data', NULL
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_responsavel WHERE id = p_id_responsavel) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_responsavel Incorreto',
            'data', NULL
        );
    
    

    ELSE

        -- gera número de registro
        SELECT CONCAT(
            DATE_FORMAT(NOW(), '%Y%m'),
            LPAD(
                IFNULL(MAX(SUBSTRING(numero_registro, 7, 4)), 0) + 1,
                4,
                '0'
            )
        )
        INTO v_numero_registro
        FROM tb_paciente
        WHERE numero_registro LIKE CONCAT(DATE_FORMAT(NOW(), '%Y%m'), '%');

        -- insert paciente
        INSERT INTO tb_paciente(
            numero_registro,
            nome,
            foto,
            data_nascimento,
            diagnostico,
            id_serie_escolar,
            id_grau_suporte
        )
        VALUES (
            v_numero_registro,
            p_nome,
            p_foto,
            p_data_nascimento,
            p_diagnostico,
            p_id_serie_escolar,
            p_id_grau_suporte
        );

        SET novo_id = LAST_INSERT_ID();

        -- vínculo responsável
        INSERT INTO tb_responsavel_paciente(id_responsavel, id_paciente)
        VALUES (p_id_responsavel, novo_id);
        
        INSERT INTO tb_paciente_habilidade (id_paciente, id_habilidade, anos_meses)
		SELECT novo_id AS id_paciente,
		h.id,
        0.0 AS anos_meses
		FROM tb_habilidade h
        WHERE NOT EXISTS (
            SELECT 1
            FROM tb_paciente_habilidade ph
            WHERE ph.id_paciente = novo_id
              AND ph.id_habilidade = h.id
        );

        CALL prc_buscar_paciente_completo(novo_id, p_mensagem);

        -- sobrescreve mensagem padrão
        SET p_mensagem = JSON_SET(
            p_mensagem,
            '$.message',
            'Paciente cadastrado com sucesso'
        );

    END IF;

END $$

DELIMITER ;


---------------------------------------------
--- ADICIONAR RELACAO PSICOPEDAGOGO PACIENTE
---------------------------------------------
DELIMITER $$

CREATE PROCEDURE prc_inserir_relacao_psicopedagogo_paciente(
    IN p_id_paciente INT,
    IN p_id_psicopedagogo INT,
    OUT p_mensagem JSON
)
BEGIN

    -- valida paciente
    IF NOT EXISTS (
        SELECT 1 FROM tb_paciente WHERE id = p_id_paciente
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'data', NULL
        );

    -- valida psicopedagogo
    ELSEIF NOT EXISTS (
        SELECT 1 FROM tb_psicopedagogo WHERE id = p_id_psicopedagogo
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Psicopedagogo não encontrado',
            'data', NULL
        );
        
	ELSEIF EXISTS (
        SELECT 1 
        FROM tb_responsavel_paciente 
        WHERE id_paciente = p_id_paciente 
          AND id_responsavel = p_id_responsavel
    ) THEN
    
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Essa relação já existe',
            'data', NULL
        );

    ELSE

        -- atualiza relação
        UPDATE tb_paciente
        SET id_psicopedagogo = p_id_psicopedagogo
        WHERE id = p_id_paciente;

        CALL prc_buscar_paciente_completo(p_id_paciente, p_mensagem);

        -- sobrescreve mensagem
        SET p_mensagem = JSON_SET(
            p_mensagem,
            '$.message',
            'Relação inserida com sucesso'
        );

    END IF;

END $$

DELIMITER ;



-----------------------------------------
-- ADICIONAR RELACAO RESPONSAVEL PACIENTE
-----------------------------------------

DELIMITER $$

CREATE PROCEDURE prc_inserir_relacao_responsavel_paciente(
    IN p_id_paciente INT,
    IN p_id_responsavel INT,
    OUT p_mensagem JSON
)
BEGIN

    IF NOT EXISTS (
        SELECT 1 FROM tb_paciente WHERE id = p_id_paciente
    ) THEN
        
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'data', NULL
        );

    ELSEIF NOT EXISTS (
        SELECT 1 FROM tb_responsavel WHERE id = p_id_responsavel
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Responsavel não encontrado',
            'data', NULL
        );
        
    ELSEIF EXISTS (
        SELECT 1 
        FROM tb_responsavel_paciente 
        WHERE id_paciente = p_id_paciente 
          AND id_responsavel = p_id_responsavel
    ) THEN
    
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Essa relação já existe',
            'data', NULL
        );

    ELSE
    
        INSERT INTO tb_responsavel_paciente(id_paciente, id_responsavel) 
        VALUES (p_id_paciente, p_id_responsavel);

        
        CALL prc_buscar_paciente_completo(p_id_paciente, p_mensagem);

        
        SET p_mensagem = JSON_SET(
            p_mensagem,
            '$.message',
            'Relação inserida com sucesso'
        );

    END IF;

END $$

DELIMITER ;


-----------------------------------------
-- ATUALIZAR PACIENTE
-----------------------------------------
DELIMITER $$

CREATE PROCEDURE prc_atualizar_paciente(
	IN p_id_paciente INT,
	IN p_nome VARCHAR(150),
    IN p_foto VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_diagnostico VARCHAR(50),
    IN p_id_serie_escolar INT,
    IN p_id_grau_suporte INT,
    OUT p_mensagem JSON
)
BEGIN
    
    IF NOT EXISTS(SELECT 1 FROM tb_serie_escolar WHERE id = p_id_serie_escolar) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_serie_esolar Incorreto',
            'data', NULL
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_grau_suporte WHERE id = p_id_grau_suporte) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_grau_suporte Incorreto',
            'data', NULL
        );
        
    ELSEIF EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
		
        -- atualiza o paciente
        UPDATE tb_paciente SET
			nome = p_nome,
            foto = p_foto,
            data_nascimento = p_data_nascimento,
            diagnostico = p_diagnostico,
            id_serie_escolar = p_id_serie_escolar,
            id_grau_suporte = p_id_grau_suporte
	WHERE id = p_id_paciente;
    
    CALL prc_buscar_paciente_completo(p_id_paciente, p_mensagem);
    
    -- sobrescreve mensagem
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 200,
            'message', 'Item atualizado com sucesso'
        );
        
	ELSE
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Paciente não encontrado'
		);
        
	END IF;
END $$

DELIMITER ;



------------------------------------------
-- DELETAR RELACAO PSICOPEDAGOGO PACIENTE
------------------------------------------

DELIMITER $$

CREATE PROCEDURE proc_delete_paciente_psicopedagogo(
	IN p_id_paciente INT,
    OUT p_mensagem JSON
)
BEGIN
	-- valida se o paciente existe
    IF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
	
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Paciente não encontrado',
            'data', NULL
		);
	
    ELSE
		
         -- remove relação
        UPDATE tb_paciente 
        SET id_psicopedagogo = NULL
        WHERE id = p_id_paciente;
        
    
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Relação desvinculada com sucesso'
        );
    
    END IF;
    
END $$

DELIMITER ; 


------------------------------------------
-- DELETAR PACIENTE E SUAS RELAÇÕES
------------------------------------------

DELIMITER $$

CREATE PROCEDURE proc_delete_familiar(
	IN p_id_paciente INT,
    OUT p_mensagem JSON
)
BEGIN
	
    -- valida se o paciente existe
    IF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
	
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Paciente não encontrado',
            'data', NULL
		);
	
    ELSE
		
        -- remove tentativas
		DELETE t
		FROM tb_tentativa t
		JOIN tb_atividade a ON a.id = t.id_atividade
		WHERE a.id_paciente = p_id_paciente;

		-- remove atividades
		DELETE FROM tb_atividade
		WHERE id_paciente = p_id_paciente;
        
        -- remove formulários do paciente
		DELETE FROM tb_formulario
		WHERE id_paciente = p_id_paciente;

		-- remove responsáveis
		DELETE FROM tb_responsavel_paciente
		WHERE id_paciente = p_id_paciente;

		-- remove habilidades
		DELETE FROM tb_paciente_habilidade
		WHERE id_paciente = p_id_paciente;

	-- remove vínculo psicopedagogo
		UPDATE tb_paciente
		SET id_psicopedagogo = NULL
		WHERE id = p_id_paciente;

		-- remove paciente
		DELETE FROM tb_paciente
		WHERE id = p_id_paciente;
        
        SET p_mensagem = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Delete realizado com sucesso!!'
        );
        
	END IF;
    
END $$

DELIMITER ;