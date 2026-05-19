DELIMITER $$

CREATE PROCEDURE prc_inserir_tentativa(
    IN p_id_tipo_aplicacao INT,
    IN p_id_atividade INT,
    IN p_resultado BOOLEAN, 
    IN p_observacao VARCHAR(1500),
    IN p_data_tentativa DATE,
    OUT p_message JSON
) BEGIN
    
    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

   IF NOT EXISTS(SELECT 1 FROM tb_tipo_aplicacao WHERE id = p_id_tipo_aplicacao) THEN
		SELECT * FROM tb_tipo_aplicacao;
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
   
   ELSEIF NOT EXISTS (SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
		SELECT * FROM tb_atividade;
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
   
   ELSE
   
		INSERT INTO tb_tentativa(
			
			id_atividade,
            id_tipo_aplicacao,
            observacao,
            data_tentativa,
            resultado
            
        ) VALUES (
			
            p_id_atividade,
            p_id_tipo_aplicacao,
            p_observacao,
            p_data_tentativa,
            p_resultado
            
        );
        
        SET p_message = JSON_OBJECT(
        
			'status', TRUE,
			'status_code', 201,
			'message', 'Inserção feita com sucesso!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
        
        CALL prc_tentativa(p_id_atividade, @resultTentativa);
   
   END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_tentativa(

	IN p_id_atividade INT,
    OUT p_message JSON

) BEGIN

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS (SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
		
    ELSE
        
		SET p_message = JSON_OBJECT(
        
			'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', (SELECT json_arrayagg(
				json_object(
                'id_atividade', id_atividade,
                'id_tentativa', id_tentativa,
                'resultado', resultado,
                'data_tentativa', data_tentativa,
                'observacao', observacao,
                'auxilio', auxilio,
                'numero_questao', numero_questao,
                'comportamento', comportamento,
				'habilidade', json_object(
					'id_habilidade', id_habilidade,
                    'nome_habilidade', nome_habilidade
                )
            )
        ) FROM vw_tentativas 
        WHERE id_atividade = p_id_atividade)
        
        );
    
    END IF;


END $$ 

DELIMITER ;