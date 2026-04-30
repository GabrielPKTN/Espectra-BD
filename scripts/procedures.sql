-- ----------------------------------
-- PROCEDURES
-- ----------------------------------

-- PROCEDURE QUE ATUALIZA O PERFIL DO PSICOPEDAGOGO
delimiter $$
CREATE PROCEDURE proc_atualizar_psicopedagogo(
	IN psic_id INT,
    IN psic_foto VARCHAR(255),
    IN psic_nome VARCHAR(150),
    IN psic_data_nascimento DATE,
    IN psic_telefone VARCHAR(20)
)
BEGIN
	DECLARE id_existe INT;
    
    SELECT COUNT(*) INTO id_existe 
    FROM tb_psicopedagogo WHERE id = psic_id;
    
    if id_existe > 0 THEN
		UPDATE tb_psicopedagogo 
        SET 
			foto = psic_foto,
			nome = psic_nome,
			data_nascimento = psic_data_nascimento,
			telefone = psic_telefone
		WHERE id = psic_id;
        
        SELECT "Atualizado com Sucesso!" as mensagem;
	ELSE
		SELECT CONCAT('O ID', psic_id, 'NÃO EXISTE!') as erro404;
	END IF;
end $$
delimiter ;

CALL proc_atualizar_psicopedagogo(
	1, -- Id do Psicopedagogo
    'psico1.jpg', -- Foto do Psicopedagogo
    'Nicolas', -- Nome do Psicopedagogo
    '2008-06-16', -- Data de nascimento do Psicopedagogo
    '(11) 96666-6666' -- Telefone do Psicopedagogo
);

-- PROCEDURE QUE ATUALIZA A SENHA DO PSICOPEDAGOGO
DELIMITER $$
CREATE PROCEDURE proc_atualizar_senha_psicopedagogo(
	IN psic_id INT, 
    IN psic_email VARCHAR(255),
    IN psic_nova_senha VARCHAR(150)
)
BEGIN
	DECLARE id_existe INT;

	SELECT COUNT(*) INTO id_existe
	FROM tb_psicopedagogo
	WHERE id = psic_id AND email = psic_email;

	IF id_existe > 0 THEN
		UPDATE tb_psicopedagogo
        SET senha = psic_nova_senha
        WHERE id = psic_id AND email = psic_email;
        
        SELECT 'Senha atualizada com sucesso!' AS mensagem;
        
	ELSE
		SELECT CONCAT('ID ou email inválido (ID: ', psic_id, ')') AS erro;
        
	END IF;
END $$
DELIMITER ;

CALL proc_atualizar_senha_psicopedagogo(
	1, -- Id do Psicopedagogo
    'ana.martins@email.com', -- Email do psicopedagogo
    'senhaN0103' -- Senha nova do psicopedagogo
)

-- PROCEDURE PARA DELETAR PSICOPEDAGOGO
DELIMITER $$
CREATE PROCEDURE proc_delete_psicopedagogo(
	IN psic_id INT
)
BEGIN
	DECLARE id_existe INT;
    
    SELECT COUNT(*) INTO id_existe
    FROM tb_psicopedagogo WHERE id = psic_id;
    
    IF id_existe > 0 THEN
		DELETE FROM tb_psicopedagogo WHERE id = psic_id;
        SELECT ("Perfil deletado com sucesso") AS mensagem;
	ELSE
		SELECT CONCAT("O ID	", psic_id, "	NÃO EXISTE!") as erro;
	END IF;
END $$
DELIMITER ;

-- Desativa temporariamente o Safe Updates
SET SQL_SAFE_UPDATES = 0;

CALL proc_delete_psicopedagogo(
	1 -- Id Psicopedagogo
);

-- PROCEDURE PARA ATUALIZAR FORMULÁRIO
DELIMITER $$
CREATE PROCEDURE proc_atualizar_respostas_formulario(
	IN form_id INT,
    IN form_atividade_portage INT,
    IN form_resposta INT
)
BEGIN 
	DECLARE id_existe INT;
    
    SELECT COUNT(*) INTO id_existe
    FROM tb_formulario WHERE id = form_id 
	AND id_atividade_portage = form_atividade_portage;
    
    IF id_existe > 0 THEN
		UPDATE tb_formulario
        SET
			id_resposta = form_resposta
		WHERE id = form_id AND id_atividade_portage = form_atividade_portage;
        
        SELECT "Formulário atualizado com sucesso!" as mensagem;
	ELSE
		SELECT CONCAT("Registro não encontrado (ID: ", form_id, ")") as erro;
	END IF;
END $$
DELIMITER ;

CALL proc_atualizar_respostas_formulario(
	2, -- Id do Formulário
    2, -- Id da Pergunta (Portage)
    3 -- Id da Resposta
);

-- PROCEDURE PARA INSERIR ATIVIDADE PORTAGE
DELIMITER $$
CREATE PROCEDURE proc_inserir_atividade_tipo_portage(
	IN portage_id_status_atividade INT,
    IN portage_id_paciente INT,
    IN portage_id INT
)
BEGIN
	DECLARE paciente_existe INT;
    
    SELECT COUNT(*) INTO paciente_existe
    FROM tb_paciente WHERE id = portage_id_paciente;
    
    IF paciente_existe > 0 THEN

		INSERT INTO tb_atividade (id_status_atividade, id_paciente, id_atividade_portage)
		VALUES (
				portage_id_status_atividade,
				portage_id_paciente,
				portage_id
		);
		SELECT "Atividade criada com sucesso!" as mensagem;
	ELSE
		SELECT "Paciente não encontrado!" as erro;
	END IF;
END$$
DELIMITER ;

CALL proc_inserir_atividade_tipo_portage(
		1, -- Id do Status da Atividade
        1, -- Id do Paciente
        1 -- Id da Atividade Portage
);

-- PROCEDURE PARA INSERIR ATIVIDADE PERSONALIZADA
DELIMITER $$
CREATE PROCEDURE proc_inserir_atividade_personalizada(
	IN personalizada_id_status_atividade INT,
    IN personalizada_id_paciente INT,
    IN personalizada_id INT,
    IN personalizada_psicopedagogo_id INT
)
BEGIN
	DECLARE paciente_existe INT;
    DECLARE personalizada_existe INT;
    
    SELECT COUNT(*) INTO personalizada_existe
    FROM tb_atividade_personalizada WHERE id = personalizada_id
    AND id_psicopedagogo = personalizada_psicopedagogo_id;
    
    SELECT COUNT(*) INTO paciente_existe
    FROM tb_paciente WHERE id = personalizada_id_paciente;
    
    IF paciente_existe > 0 AND personalizada_existe > 0 THEN
		INSERT INTO tb_atividade(id_status_atividade, id_paciente, id_atividade_personalizada)
        VALUES (
			personalizada_id_status_atividade,
            personalizada_id_paciente,
            personalizada_id
        );
        SELECT "Atividade criada com sucesso!" as mensagem;
	ELSEIF paciente_existe = 0 THEN
		SELECT "Paciente não encontrado!" as erro;
	ELSE 
		SELECT "Atividade não pertence ao psicopedagogo ou não existe!" as erro;
	END IF;
END $$
DELIMITER ;

CALL proc_inserir_atividade_personalizada(
	1, -- Id do Status da Atividade 
    1, -- id do Paciente
    1, -- Id da Atividade Personalizada
    1 -- Id do Psicopedagogo
);

-- PROCEDURE PARA ATUALIZAR ATIVIDADE PERSONALIZADA
DELIMITER $$
CREATE PROCEDURE proc_atualizar_atividade_personalizada(
	IN personalizada_id INT,
    IN personalizada_questao VARCHAR(300),
    IN personalizada_valor_meses INT,
    IN personalizada_habilidade_id INT
)
	BEGIN
		DECLARE personalizada_existe INT;
        
        SELECT COUNT(*) INTO personalizada_existe
        FROM tb_atividade_personalizada WHERE id = personalizada_id;
        
        IF personalizada_existe > 0 THEN
			UPDATE tb_atividade_personalizada
			SET
				questao = personalizada_questao,
                valor_meses = personalizada_valor_meses,
                id_habilidade = personalizada_habilidade_id
				WHERE id = personalizada_id;
                
			SELECT "Atividade atualizada com sucesso!" as mensagem;
		ELSE
			SELECT "Atividade não encontrada!" as erro;
        END IF;
    END$$
DELIMITER ;

CALL proc_atualizar_atividade_personalizada(
	1, -- Id da Atividade Personalizada
    'Nova questão', -- Nome da Atividade (Questão)
    12, -- Valor em meses
    6 -- Id da Habilidade
);

-- PROCEDURE QUE DELETA A ATIVIDADE PERSONALIZADA E SEU REGISTRO NA TABELA ATIVIDADE
DELIMITER $$
CREATE PROCEDURE proc_delete_tipo_atividade_personalizada(
	IN personalizada_id INT
)
	BEGIN
		DECLARE personalizada_existe INT;
        
        SELECT COUNT(*) INTO personalizada_existe
        FROM tb_atividade_personalizada WHERE id = personalizada_id;
        
        IF personalizada_existe > 0 THEN
			DELETE FROM tb_atividade WHERE id_atividade_personalizada = personalizada_id;
            
            DELETE FROM tb_atividade_personalizada WHERE id = personalizada_id;
            
            SELECT "Atividade deletada com sucesso!";
        ELSE
			SELECT "Atividade não encontrada!";
        END IF;
    END$$
DELIMITER ;

CALL proc_delete_tipo_atividade_personalizada(
	1 -- Id da Atividade que deseja deletar
);

-- PROCEDURE QUE DELETA ATIVIDADE PORTAGE NA TABELA ATIVIDADE
DELIMITER $$
CREATE PROCEDURE proc_delete_atividade_tipo_portage(
	IN portage_id INT
)
	BEGIN
		DECLARE portage_existe INT;
        
        SELECT COUNT(*) INTO portage_existe
		FROM tb_atividade
		WHERE id_atividade_portage = portage_id;
        
        IF portage_existe > 0 THEN
			DELETE t FROM tb_tentativa t JOIN tb_atividade a ON t.id_atividade = a.id WHERE a.id_atividade_portage = portage_id;
                    
			DELETE FROM tb_atividade WHERE id_atividade_portage = portage_id;
            
            SELECT "Atividade deletada com sucesso!";
		ELSE
			SELECT "Atividade não encontrada!";
		END IF;
    END$$
DELIMITER ;

CALL proc_delete_atividade_tipo_portage(
	2 -- Id da Atividade Portage
);

-- PROCEDURE PARA INSERIR TENTATIVA
DELIMITER $$
CREATE PROCEDURE proc_inserir_tentativa(
	IN tipo_aplicacao_id INT,
    IN atividade_id INT,
    IN tentativa_resultado BOOLEAN, 
    IN tentativa_observacao VARCHAR(1500),
    IN tentativa_data_tentativa DATE
)
	BEGIN
		DECLARE tipo_aplicacao_existe INT;
        DECLARE atividade_existe INT;
        
        SELECT COUNT(*) INTO tipo_aplicacao_existe
        FROM tb_tipo_aplicacao WHERE id = tipo_aplicacao_id;
        
        SELECT COUNT(*) INTO atividade_existe
        FROM tb_atividade WHERE id = atividade_id;
        
        IF tipo_aplicacao_existe > 0 AND atividade_existe > 0 THEN
			INSERT INTO tb_tentativa (resultado, observacao, data_tentativa, id_tipo_aplicacao, id_atividade)
            VALUES (
				tentativa_resultado,
                tentativa_observacao,
                tentativa_data_tentativa,
                tipo_aplicacao_id,
                atividade_id
            );
            
            SELECT "Tentativa cadastrada com sucesso!";
		ELSE
			SELECT "Tipo da aplicação ou Atividade não encontrada!";
		END IF;
    END$$
DELIMITER ;

CALL proc_inserir_tentativa(
	1, -- Id do Tipo de Aplicação
    9, -- Id da Atividade
    TRUE, -- Êxito ou falha (True ou False)
    'Tentativa realizada com auxílio total, possibilidade de melhora', -- Observação
    '2026-04-20' -- Data da tentativa
);

-- PROCEDURE QUE LISTA OS DADOS DA HOME DE UM PSICOPEDAGOGO
DELIMITER $$

CREATE PROCEDURE prc_buscar_psicopedagogo_home(
    IN p_id_psicopedagogo INT,
    OUT p_mensagem JSON
)
BEGIN

    -- DADOS DO PSICOPEDAGOGO
    DECLARE v_nome VARCHAR(150);
    DECLARE v_foto VARCHAR(255);

    -- JSON FINAL DE PACIENTES
    DECLARE v_pacientes JSON;

    -- VALIDAÇÃO
    IF NOT EXISTS (
        SELECT 1 
        FROM tb_psicopedagogo 
        WHERE id = p_id_psicopedagogo
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Psicopedagogo não encontrado',
            'data', NULL
        );

    ELSE

        -- DADOS DO PSICOPEDAGOGO
        SELECT nome, foto
        INTO v_nome, v_foto
        FROM tb_psicopedagogo
        WHERE id = p_id_psicopedagogo
        LIMIT 1;

        -- PACIENTES + RESPONSÁVEIS
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', p.id,
                'foto', p.foto,
                'nome', p.nome,
                'data_nascimento', p.data_nascimento,
                'idade', TIMESTAMPDIFF(YEAR, p.data_nascimento, CURDATE()),
                'diagnostico', p.diagnostico,
                'serie_escolar', s.serie,
                'grau_suporte', g.grau,
                'numero_registro', p.numero_registro,

                'responsavel', (
                    SELECT IFNULL(JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'id', r.id,
                            'nome', r.nome,
                            'telefone', r.telefone
                        )
                    ), JSON_ARRAY())
                    FROM tb_responsavel_paciente rp
                    JOIN tb_responsavel r ON r.id = rp.id_responsavel
                    WHERE rp.id_paciente = p.id
                )
            )
        )
        INTO v_pacientes
        FROM tb_paciente p
        LEFT JOIN tb_serie_escolar s ON s.id = p.id_serie_escolar
        LEFT JOIN tb_grau_suporte g ON g.id = p.id_grau_suporte
        WHERE p.id_psicopedagogo = p_id_psicopedagogo;

        SET v_pacientes = IFNULL(v_pacientes, JSON_ARRAY());

        -- JSON FINAL
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Psicopedagogo encontrado',
            'data', JSON_OBJECT(
                'id', p_id_psicopedagogo,
                'foto', v_foto,
                'nome', v_nome,
                'paciente', v_pacientes
            )
        );

    END IF;

END$$

DELIMITER ;