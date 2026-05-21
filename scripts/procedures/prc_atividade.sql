drop procedure prc_inserir_atividade_tipo_portage;
drop procedure prc_inserir_atividade_tipo_personalizada;
drop procedure prc_atualiza_atividade_personalizada;
drop procedure prc_delete_atividade;
drop procedure prc_atividades;

DELIMITER $$

CREATE PROCEDURE prc_inserir_atividade_tipo_portage(
    IN p_id_usuario INT,
    IN p_id_paciente INT,
    IN p_id_atividade_portage INT,
    OUT p_message JSON
) BEGIN

    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

    IF NOT EXISTS (SELECT 1 FROM tb_usuario where id = p_id_usuario) THEN
    
        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = p_id_paciente) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
        
	ELSEIF EXISTS (SELECT 1 FROM tb_atividade WHERE id_atividade_portage = p_id_atividade_portage) THEN 

		SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Essa relação já existe',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_atividade_portage WHERE id = p_id_atividade_portage) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSE

        INSERT INTO tb_atividade (

            id_paciente,
            id_atividade_portage

        ) VALUES (

            p_id_paciente,
            p_id_atividade_portage

        );

        SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Inserção feita com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        call prc_atividades(p_id_paciente, 
		( SELECT id_habilidade FROM tb_atividade_portage WHERE id = p_id_atividade_portage )
        , @resultAtividade);


    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_inserir_atividade_tipo_personalizada(
    IN p_id_usuario INT,
    IN p_id_paciente INT,
    IN p_comportamento VARCHAR(300),
    IN p_valor_meses INT,
    IN p_id_habilidade INT,
    OUT p_message JSON
) BEGIN

	DECLARE last_id_atividade_personalizada INT;
    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

    IF NOT EXISTS (SELECT 1 FROM tb_usuario where id = p_id_usuario) THEN
    
        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = p_id_paciente) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
	
	ELSE
    
		INSERT INTO tb_atividade_personalizada(
			
			comportamento,
            valor_meses,
            id_habilidade,
            id_usuario
            
        ) VALUES (
        
			p_comportamento,
            p_valor_meses,
            p_id_habilidade,
            p_id_usuario
        
        );
        
        SET last_id_atividade_personalizada = LAST_INSERT_ID();
        
        INSERT INTO tb_atividade(
        
			id_paciente,
            id_atividade_personalizada
            
        ) VALUES (
			
            p_id_paciente,
            last_id_atividade_personalizada
            
        );
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 201,
            'message', 'Cadastro bem sucedido!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
        
        call prc_atividades(p_id_paciente, p_id_habilidade, @resultAtividade);
    
    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualiza_atividade_personalizada(
	IN p_id_atividade INT,
    IN p_id_usuario INT,
    IN p_comportamento VARCHAR(300),
    IN p_valor_meses INT,
    OUT p_message JSON
) BEGIN

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();
    
    IF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id_usuario) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS(
    
    SELECT 1 FROM tb_atividade_personalizada WHERE id = (
		SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade
    ) AND id_usuario = p_id_usuario ) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
    
    ELSE 
    
		UPDATE tb_atividade_personalizada
        SET 
			comportamento = p_comportamento,
            valor_meses = p_valor_meses
		WHERE id = (
			SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade
        );
    
		SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
		call prc_atividades(
		(SELECT id_paciente FROM tb_atividade WHERE id_atividade_personalizada = (SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade)), 
		(SELECT id_habilidade FROM tb_atividade_personalizada WHERE id = (SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade)),
        @resultAtividade);
    
	END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_delete_atividade(
    IN p_id_usuario INT,
    IN p_id_paciente INT,
    IN p_id_atividade INT,
    OUT p_message JSON
) BEGIN

    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();
    
	IF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS (SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
        
	ELSEIF NOT EXISTS (
    
		SELECT 1 
        FROM tb_atividade atividade
        INNER JOIN tb_usuario_paciente relacao ON relacao.id_paciente = atividade.id_paciente
        WHERE atividade.id = p_id_atividade 
          AND atividade.id_paciente = p_id_paciente 
          AND relacao.id_usuario = p_id_usuario
    
	) THEN 
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
        
	ELSE
    
		IF ((SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade) IS NOT NULL) THEN
        
			call prc_atividades(p_id_paciente, 
			( SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade )
			, @resultAtividade);
            
		ELSE
        
			call prc_atividades(p_id_paciente, 
			( SELECT id_atividade_portage FROM tb_atividade WHERE id = p_id_atividade )
			, @resultAtividade);
        
        END IF;
    
		DELETE FROM tb_atividade WHERE id = p_id_atividade;
		
        SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Atividade excluída com sucesso.',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    END IF;
    

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atividades(
	IN p_id_paciente INT,
    IN p_id_habilidade INT,
    OUT p_message JSON
) BEGIN

	DECLARE atividades JSON;

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS(SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
		
        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_habilidade WHERE id = p_id_habilidade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
	ELSE
    
		-- portage
		SELECT JSON_ARRAYAGG(
			JSON_OBJECT(
				
                'id_atividade', id_atividade,
                'concluida', concluida,
                'numero_questao', numero_questao,
                'comportamento', comportamento,
                'habilidade', JSON_OBJECT(
					'id_habilidade', id_habilidade,
					'nome_habilidade', nome_habilidade
				)
            )
        )
        FROM vw_todas_atividades
        WHERE id_paciente = p_id_paciente
        AND id_habilidade = p_id_habilidade
		INTO atividades;
        
        SET p_message = JSON_OBJECT(
			
			'status', TRUE,
			'status_code', '200',
			'message', 'Requisição feita com sucesso!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
			'data', atividades
            
        );
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualiza_status_atividade(
	IN p_id_atividade INT,
    OUT p_message JSON
) BEGIN

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS(SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
		
    ELSE
		
		UPDATE tb_atividade SET
			concluida = TRUE
		WHERE id = p_id_atividade;
        
        IF EXISTS (
        
			SELECT 1 FROM tb_atividade WHERE id = p_id_atividade AND id_atividade_portage IS NOT NULL
        
        ) THEN
        
			UPDATE tb_formulario SET
				id_resposta = 1
            WHERE id_paciente = (SELECT id_paciente FROM tb_atividade WHERE id = p_id_atividade) -- Retorna o id do paciente que essa atividade pertence
			AND id_atividade_portage = (SELECT id_atividade_portage FROM tb_atividade WHERE id = p_id_atividade);
        
        END IF;
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    END IF;

END$$

DELIMITER ;