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