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

DELIMITER $$

CREATE PROCEDURE prc_atualizar_psicopedagogo(
    IN p_id INT,
    IN p_foto VARCHAR(255),
    IN p_nome VARCHAR(150),
    IN p_data_nascimento DATE,
    IN p_telefone VARCHAR(20),
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_existe INT;

    -- VALIDAÇÃO
    SELECT COUNT(*) INTO v_existe
    FROM tb_psicopedagogo
    WHERE id = p_id;

    IF v_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Psicopedagogo não encontrado',
            'data', NULL
        );

    ELSE

        -- UPDATE
        UPDATE tb_psicopedagogo
        SET
            foto = p_foto,
            nome = p_nome,
            data_nascimento = p_data_nascimento,
            telefone = p_telefone
        WHERE id = p_id;

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Perfil atualizado com sucesso',
            'data', JSON_OBJECT(
                'id', p_id,
                'foto', p_foto,
                'nome', p_nome,
                'data_nascimento', p_data_nascimento,
                'telefone', p_telefone
            )
        );

    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualizar_senha_psicopedagogo(
    IN p_id INT,
    IN p_email VARCHAR(255),
    IN p_nova_senha VARCHAR(150),
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_existe INT;

    -- VALIDAÇÃO
    SELECT COUNT(*) INTO v_existe
    FROM tb_psicopedagogo
    WHERE id = p_id AND email = p_email;

    IF v_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'ID ou email inválido',
            'data', NULL
        );

    ELSE

        -- UPDATE
        UPDATE tb_psicopedagogo
        SET senha = p_nova_senha
        WHERE id = p_id AND email = p_email;

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Senha atualizada com sucesso',
            'data', JSON_OBJECT(
                'id', p_id,
                'email', p_email
            )
        );

    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_delete_psicopedagogo(
    IN p_id INT,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_existe INT;

    -- VALIDAÇÃO
    SELECT COUNT(*) INTO v_existe
    FROM tb_psicopedagogo
    WHERE id = p_id;

    IF v_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Psicopedagogo não encontrado',
            'data', NULL
        );

    ELSE

        -- DELETE
        DELETE FROM tb_psicopedagogo
        WHERE id = p_id;

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Psicopedagogo deletado com sucesso',
            'data', JSON_OBJECT(
                'id', p_id
            )
        );

    END IF;

END$$

DELIMITER ;

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

DELIMITER $$

CREATE PROCEDURE prc_login_psicopedagogo(
    IN p_email VARCHAR(255),
    IN p_senha VARCHAR(255),
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_id INT;

    -- VALIDAÇÃO
    IF NOT EXISTS (
        SELECT 1 
        FROM tb_psicopedagogo 
        WHERE email = p_email
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Email não encontrado',
            'data', NULL
        );

    ELSEIF NOT EXISTS (
        SELECT 1 
        FROM tb_psicopedagogo 
        WHERE email = p_email AND senha = p_senha
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 401,
            'message', 'Senha incorreta',
            'data', NULL
        );

    ELSE

        -- DADOS DO USUÁRIO
        SELECT 
            id
        INTO
            v_id
        FROM tb_psicopedagogo
        WHERE email = p_email AND senha = p_senha
        LIMIT 1;

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Login realizado com sucesso',
            'data', JSON_OBJECT(
                'id', v_id
            )
        );

    END IF;

END$$

DELIMITER ;