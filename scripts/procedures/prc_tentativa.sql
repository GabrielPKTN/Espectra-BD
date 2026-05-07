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