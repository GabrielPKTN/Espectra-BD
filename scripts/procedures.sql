-- ----------------------------------
-- PROCEDURES
-- ----------------------------------

-- PROCEDURE QUE ATUALIZA O PERFIL DO PSICOPEDAGOGO
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

-- PROCEDURE QUE ATUALIZA A SENHA DO PSICOPEDAGOGO
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
 
-- PROCEDURE PARA DELETAR PSICOPEDAGOGO
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

-- PROCEDURE PARA ATUALIZAR FORMULÁRIO
DELIMITER $$

CREATE PROCEDURE prc_atualizar_respostas_formulario(
    IN p_form_id INT,
    IN p_atividade_portage_id INT,
    IN p_resposta_id INT,
    OUT p_mensagem JSON
)
BEGIN 

    DECLARE v_existe INT;

    -- VALIDAÇÃO
    SELECT COUNT(*) INTO v_existe
    FROM tb_formulario
    WHERE id = p_form_id
      AND id_atividade_portage = p_atividade_portage_id;

    IF v_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Registro não encontrado',
            'data', NULL
        );

    ELSE

        -- UPDATE
        UPDATE tb_formulario
        SET id_resposta = p_resposta_id
        WHERE id = p_form_id
          AND id_atividade_portage = p_atividade_portage_id;

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Resposta do formulário atualizada com sucesso',
            'data', JSON_OBJECT(
                'id_formulario', p_form_id,
                'id_atividade_portage', p_atividade_portage_id,
                'id_resposta', p_resposta_id
            )
        );

    END IF;

END $$

DELIMITER ;


-- PROCEDURE PARA INSERIR ATIVIDADE PORTAGE
DELIMITER $$

CREATE PROCEDURE prc_inserir_atividade_tipo_portage(
    IN p_status_id INT,
    IN p_paciente_id INT,
    IN p_portage_id INT,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_paciente_existe INT;
    DECLARE v_portage_existe INT;
    DECLARE v_status_existe INT;
    DECLARE v_id_atividade INT;

    -- VALIDAÇÕES
    SELECT COUNT(*) INTO v_paciente_existe
    FROM tb_paciente 
    WHERE id = p_paciente_id;

    SELECT COUNT(*) INTO v_portage_existe
    FROM tb_atividade_portage 
    WHERE id = p_portage_id;

    SELECT COUNT(*) INTO v_status_existe
    FROM tb_status_atividade 
    WHERE id = p_status_id;

    -- ERROS ESPECÍFICOS
    IF v_paciente_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'data', NULL
        );

    ELSEIF v_portage_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Atividade portage não encontrada',
            'data', NULL
        );

    ELSEIF v_status_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Status da atividade não encontrado',
            'data', NULL
        );

    ELSE

        -- INSERT
        INSERT INTO tb_atividade (
            id_status_atividade,
            id_paciente,
            id_atividade_portage
        )
        VALUES (
            p_status_id,
            p_paciente_id,
            p_portage_id
        );

        SET v_id_atividade = LAST_INSERT_ID();

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Atividade portage criada com sucesso',
            'data', JSON_OBJECT(
                'id_atividade', v_id_atividade,
                'id_status_atividade', p_status_id,
                'id_paciente', p_paciente_id,
                'id_atividade_portage', p_portage_id
            )
        );

    END IF;

END$$

DELIMITER ;

-- PROCEDURE PARA INSERIR ATIVIDADE PERSONALIZADA
DELIMITER $$

CREATE PROCEDURE prc_inserir_atividade_personalizada(
    IN p_status_id INT,
    IN p_paciente_id INT,
    IN p_personalizada_id INT,
    IN p_psicopedagogo_id INT,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_paciente_existe INT;
    DECLARE v_personalizada_existe INT;
    DECLARE v_status_existe INT;
    DECLARE v_id_atividade INT;

    -- VALIDAÇÕES
    SELECT COUNT(*) INTO v_paciente_existe
    FROM tb_paciente
    WHERE id = p_paciente_id;

    SELECT COUNT(*) INTO v_personalizada_existe
    FROM tb_atividade_personalizada
    WHERE id = p_personalizada_id
      AND id_psicopedagogo = p_psicopedagogo_id;

    SELECT COUNT(*) INTO v_status_existe
    FROM tb_status_atividade
    WHERE id = p_status_id;

    -- ERROS ESPECÍFICOS
    IF v_paciente_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'data', NULL
        );

    ELSEIF v_personalizada_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Atividade personalizada não existe ou não pertence ao psicopedagogo',
            'data', NULL
        );

    ELSEIF v_status_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Status da atividade não encontrado',
            'data', NULL
        );

    ELSE

        -- INSERT
        INSERT INTO tb_atividade (
            id_status_atividade,
            id_paciente,
            id_atividade_personalizada
        )
        VALUES (
            p_status_id,
            p_paciente_id,
            p_personalizada_id
        );

        SET v_id_atividade = LAST_INSERT_ID();

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Atividade personalizada criada com sucesso',
            'data', JSON_OBJECT(
                'id_atividade', v_id_atividade,
                'id_status_atividade', p_status_id,
                'id_paciente', p_paciente_id,
                'id_atividade_personalizada', p_personalizada_id
            )
        );

    END IF;

END$$

DELIMITER ;

-- PROCEDURE PARA ATUALIZAR ATIVIDADE PERSONALIZADA
DELIMITER $$

CREATE PROCEDURE prc_atualizar_atividade_personalizada(
    IN p_id INT,
    IN p_questao VARCHAR(300),
    IN p_valor_meses INT,
    IN p_habilidade_id INT,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_existe INT;
    DECLARE v_habilidade_existe INT;

    -- VALIDAÇÃO: atividade existe
    SELECT COUNT(*) INTO v_existe
    FROM tb_atividade_personalizada
    WHERE id = p_id;

    -- VALIDAÇÃO: habilidade existe
    SELECT COUNT(*) INTO v_habilidade_existe
    FROM tb_habilidade
    WHERE id = p_habilidade_id;

    IF v_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Atividade personalizada não encontrada',
            'data', NULL
        );

    ELSEIF v_habilidade_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Habilidade não encontrada',
            'data', NULL
        );

    ELSE

        -- UPDATE
        UPDATE tb_atividade_personalizada
        SET
            questao = p_questao,
            valor_meses = p_valor_meses,
            id_habilidade = p_habilidade_id
        WHERE id = p_id;

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Atividade personalizada atualizada com sucesso',
            'data', JSON_OBJECT(
                'id', p_id,
                'questao', p_questao,
                'valor_meses', p_valor_meses,
                'id_habilidade', p_habilidade_id
            )
        );

    END IF;

END$$

DELIMITER ;

-- PROCEDURE QUE DELETA A ATIVIDADE PERSONALIZADA E SEU REGISTRO NA TABELA ATIVIDADE
DELIMITER $$

CREATE PROCEDURE prc_delete_atividade_personalizada(
    IN p_personalizada_id INT,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_existe INT;
    DECLARE v_qtd_atividades INT DEFAULT 0;

    -- VALIDAÇÃO
    SELECT COUNT(*) INTO v_existe
    FROM tb_atividade_personalizada
    WHERE id = p_personalizada_id;

    IF v_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Atividade personalizada não encontrada',
            'data', NULL
        );

    ELSE

        SELECT COUNT(*) INTO v_qtd_atividades
        FROM tb_atividade
        WHERE id_atividade_personalizada = p_personalizada_id;

        DELETE FROM tb_atividade
        WHERE id_atividade_personalizada = p_personalizada_id;

        DELETE FROM tb_atividade_personalizada
        WHERE id = p_personalizada_id;

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Atividade personalizada deletada com sucesso',
            'data', JSON_OBJECT(
                'id_atividade_personalizada', p_personalizada_id,
                'atividades_removidas', v_qtd_atividades
            )
        );

    END IF;

END$$

DELIMITER ;

-- PROCEDURE QUE DELETA ATIVIDADE PORTAGE NA TABELA ATIVIDADE
DELIMITER $$

CREATE PROCEDURE prc_delete_atividade_tipo_portage(
    IN p_portage_id INT,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_existe INT;
    DECLARE v_qtd_atividades INT DEFAULT 0;
    DECLARE v_qtd_tentativas INT DEFAULT 0;

    -- VALIDAÇÃO
    SELECT COUNT(*) INTO v_existe
    FROM tb_atividade
    WHERE id_atividade_portage = p_portage_id;

    IF v_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Atividade portage não encontrada',
            'data', NULL
        );

    ELSE

        SELECT COUNT(*) INTO v_qtd_tentativas
        FROM tb_tentativa t
        JOIN tb_atividade a ON t.id_atividade = a.id
        WHERE a.id_atividade_portage = p_portage_id;

        DELETE t FROM tb_tentativa t
        JOIN tb_atividade a ON t.id_atividade = a.id
        WHERE a.id_atividade_portage = p_portage_id;

        SELECT COUNT(*) INTO v_qtd_atividades
        FROM tb_atividade
        WHERE id_atividade_portage = p_portage_id;

        DELETE FROM tb_atividade
        WHERE id_atividade_portage = p_portage_id;

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Atividades portage deletadas com sucesso',
            'data', JSON_OBJECT(
                'id_atividade_portage', p_portage_id,
                'atividades_removidas', v_qtd_atividades,
                'tentativas_removidas', v_qtd_tentativas
            )
        );

    END IF;

END$$

DELIMITER ;

-- PROCEDURE DE INSERIR TENTATIVA
DELIMITER $$

CREATE PROCEDURE prc_inserir_tentativa(
    IN p_tipo_aplicacao_id INT,
    IN p_atividade_id INT,
    IN p_resultado BOOLEAN, 
    IN p_observacao VARCHAR(1500),
    IN p_data DATE,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE v_tipo_existe INT;
    DECLARE v_atividade_existe INT;
    DECLARE v_id_tentativa INT;

    -- VALIDAÇÕES
    SELECT COUNT(*) INTO v_tipo_existe
    FROM tb_tipo_aplicacao 
    WHERE id = p_tipo_aplicacao_id;

    SELECT COUNT(*) INTO v_atividade_existe
    FROM tb_atividade 
    WHERE id = p_atividade_id;

    IF v_tipo_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Tipo de aplicação não encontrado',
            'data', NULL
        );

    ELSEIF v_atividade_existe = 0 THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Atividade não encontrada',
            'data', NULL
        );

    ELSE

        -- INSERT
        INSERT INTO tb_tentativa (
            resultado,
            observacao,
            data_tentativa,
            id_tipo_aplicacao,
            id_atividade
        )
        VALUES (
            p_resultado,
            p_observacao,
            p_data,
            p_tipo_aplicacao_id,
            p_atividade_id
        );

        SET v_id_tentativa = LAST_INSERT_ID();

        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Tentativa cadastrada com sucesso',
            'data', JSON_OBJECT(
                'id', v_id_tentativa,
                'resultado', p_resultado,
                'observacao', p_observacao,
                'data_tentativa', p_data,
                'id_tipo_aplicacao', p_tipo_aplicacao_id,
                'id_atividade', p_atividade_id
            )
        );

    END IF;

END$$

DELIMITER ;

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

-- PROCEDURE QUE RETORNA OS DADOS DE UM PSICOPEDAGOGO VALIDANDO POR EMAIL E SENHA
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