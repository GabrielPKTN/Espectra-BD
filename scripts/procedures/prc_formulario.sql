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