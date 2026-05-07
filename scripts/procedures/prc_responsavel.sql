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