DELIMITER $$
drop procedure prc_atualizar_respostas_formulario;
CREATE PROCEDURE prc_atualizar_respostas_formulario(
	IN p_id_usuario INT,
    IN p_id_paciente INT,
    IN p_lista_respostas JSON,
    OUT p_message JSON
) BEGIN 

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS(SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = p_id_paciente) THEN
    
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
    
		-- INICIA UPDATE NA TABELA FORMULARIO
		UPDATE tb_formulario
		JOIN JSON_TABLE( -- JOIN CRIA A TABELA VIRTUAL, E JSON_TABLE É RESPONSÁVEL POR LER OS JSONS
			p_lista_respostas, -- ARRAY JSON VINDO DO BACK
			'$[*]' COLUMNS ( -- [*] QUER DIZER: PERCORRA TODOS OS OBJETOS DENTRO DO ARRAY JSON
				id_atividade_portage INT PATH '$.id_atividade_portage', -- CRIA COLUNA VIRTUAL, O PATH INDICA ONDE PROCURAR NO JSON
				id_resposta INT PATH '$.id_resposta'
			)
		) AS novo_formulario 
		
		ON tb_formulario.id_atividade_portage = novo_formulario.id_atividade_portage -- ENCONTRE A LINHA DE TB_FORMULARIO ONDE O ID DA ATIVIDADE PORTAGE SEJA IGUAL A QUE VEM DO JSON
		SET tb_formulario.id_resposta = novo_formulario.id_resposta -- PEGUE O VALOR DE RESPOSTA QUE ESTÁ NO BANCO E SUBSTITUA PELO VALOR DE RESPOSTA VINDO DO JSON
		WHERE tb_formulario.id_paciente = p_id_paciente;
		
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_buscar_paciente_completo(p_id_paciente, @resultPaciente);
        
    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_formulario_pelo_id_paciente(
	IN p_id_usuario INT,
    IN p_id_paciente INT,
    OUT p_message JSON
	
) BEGIN

	DECLARE array_comportamento JSON;
	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();
    
    
    IF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
        
	ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
        
	ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario_paciente WHERE id_paciente = p_id_paciente AND id_usuario = p_id_usuario) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
        
	ELSE
		
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
				'id_atividade_portage', id_atividade,
                'numero_questao', numero_questao,
                'comportamento', comportamento,
                'id_faixa_idade', id_faixa_idade,
                'id_habilidade', id_habilidade,
                'id_resposta', id_resposta
            )
        ) FROM vw_formulario_usuario WHERE id_paciente = p_id_paciente
        INTO array_comportamento;
        
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', '200',
            'message', 'Formulario encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', array_comportamento
        );
    
    END IF;

END$$

DELIMITER ;


