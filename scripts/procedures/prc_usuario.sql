-- --------- Legenda ------------
-- p = parametro
-- v = variavel
-- ------------------------------

drop procedure prc_usuario;
drop procedure prc_home;
drop procedure prc_usuario_login;
drop procedure prc_cria_usuario;
drop procedure prc_atualiza_usuario;
drop procedure prc_solicita_redefinicao_senha;
drop procedure prc_atualiza_senha_usuario;
drop procedure prc_deleta_usuario;

DELIMITER $$

CREATE PROCEDURE prc_usuario(
	IN p_id INT,
    OUT p_message JSON
) BEGIN
	
    DECLARE v_foto VARCHAR(255);
    DECLARE v_nome VARCHAR(150);
    DECLARE v_data_nascimento DATE;
    DECLARE v_telefone VARCHAR(20);
    DECLARE v_email VARCHAR(255);
    
    DECLARE data_hoje DATE;
    SET data_hoje = curdate();
		
    IF NOT EXISTS (
		
        SELECT 1
        FROM tb_usuario
        WHERE id = p_id
        
    ) THEN 
		SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Não foram encontrados dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    ELSE
		
        SELECT foto, nome, data_nascimento, telefone, email
        INTO v_foto, v_nome, v_data_nascimento, v_telefone, v_email
        FROM tb_usuario
        WHERE id = p_id;
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', JSON_OBJECT(
				'id', p_id,
                'foto', v_foto,
                'nome', v_nome,
                'email', v_email,
                'data_nascimento', v_data_nascimento,
                'telefone', v_telefone
            )
        );
    
    END IF;
    
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_usuario_login(
    IN p_email VARCHAR(255),
    IN p_senha VARCHAR(255),
    OUT v_id INT,
    OUT p_message JSON
) BEGIN

	DECLARE data_hoje DATE;

	SET data_hoje = CURDATE();

	SELECT id INTO v_id
	FROM tb_usuario 
	WHERE email = p_email AND senha = p_senha;

    IF v_id IS NULL THEN

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
            'message', 'Requisição feita com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_home(v_id, @resultHome);
        
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_home(
	IN p_id_usuario INT,
    OUT p_message JSON
) BEGIN 
	
    DECLARE v_id INT;
    DECLARE v_foto VARCHAR(150);
    DECLARE v_nome VARCHAR(255);
	DECLARE v_tipo_usuario VARCHAR(40);
    DECLARE data_hoje DATE;
    DECLARE return_object JSON;
    
    SET data_hoje = curdate();
    
    IF NOT EXISTS (
		SELECT 1
		FROM tb_usuario
        WHERE id = p_id_usuario 
    
    ) THEN SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Não foram encontrados dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
	
    ELSE
    
		SELECT usuario.nome, usuario.foto, tipo_usuario.tipo_usuario
        INTO v_nome, v_foto, v_tipo_usuario
        FROM tb_usuario usuario
        INNER JOIN tb_tipo_usuario tipo_usuario
        ON tipo_usuario.id = usuario.id_tipo_usuario
        WHERE usuario.id = p_id_usuario;
        
        SELECT JSON_ARRAYAGG(
			JSON_OBJECT(
				'id', paciente.id,
                'foto', paciente.foto,
                'nome', paciente.nome,
                'data_nascimento', DATE_FORMAT(paciente.data_nascimento, '%d/%m/%Y'),
                'idade', TIMESTAMPDIFF(YEAR, paciente.data_nascimento, CURDATE()),
                'cpf', paciente.cpf,
                'serie_escolar', serie.serie,
                'grau_suporte', grau_suporte.grau,
                'diagnostico_breve', (
					SELECT IFNULL(JSON_ARRAYAGG(
						JSON_OBJECT(
							'id_transtorno', diagnostico.id,
							'sigla', diagnostico.sigla,
                            'nome_completo', diagnostico.nome_completo_transtorno
                        )
                    ), JSON_ARRAY())
                    FROM tb_paciente_transtorno transtorno
                    JOIN tb_sigla_transtorno diagnostico
                    ON transtorno.id_sigla_transtorno = diagnostico.id
                    WHERE transtorno.id_paciente = paciente.id
                )
            )
        )
        
        INTO return_object
        FROM tb_paciente paciente
        JOIN tb_usuario_paciente relacao
        ON relacao.id_paciente = paciente.id
        JOIN tb_serie_escolar serie
        ON serie.id = paciente.id_serie_escolar
        JOIN tb_grau_suporte grau_suporte
        ON grau_suporte.id = paciente.id_grau_suporte
        WHERE relacao.id_usuario = p_id_usuario
        ORDER BY paciente.id ASC;
        
        IF v_tipo_usuario = 'Psicopedagogo' THEN 
        
			SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', JSON_OBJECT(
                'id', p_id_usuario,
                'foto', v_foto,
                'nome', v_nome,
                'tipo_usuario', v_tipo_usuario,
                'pacientes', return_object                
            )
        );
        
        ELSE 
         
         SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', JSON_OBJECT(
                'id', p_id_usuario,
                'foto', v_foto,
                'nome', v_nome,
                'tipo_usuario', v_tipo_usuario,
                'familiares', return_object
            )
        );
        
        END IF;
        
    END IF; 

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_cria_usuario(
	IN p_nome VARCHAR(150),
    IN p_email VARCHAR(255),
    IN p_senha VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_telefone VARCHAR(20),
    IN p_id_tipo_usuario INT,
    OUT p_message JSON
) BEGIN
	
	DECLARE data_hoje DATE;

	SET data_hoje = CURDATE();
    
    IF EXISTS(
    
		SELECT 1 
        FROM tb_usuario 
        WHERE email = p_email
        
    ) THEN SET p_message = JSON_OBJECT(
			'status', FALSE,
            'status_code', 409,
            'message', 'Existem dados de inserção já cadastrados no sistema!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
        
    ELSE
    
		INSERT INTO tb_usuario (
				nome,
				data_nascimento,
				telefone,
				email,
				senha,
				id_tipo_usuario
		) VALUES (
				p_nome,
				p_data_nascimento,
				p_telefone,
				p_email,
				p_senha,
				p_id_tipo_usuario
		);
		
		SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 201,
            'message', 'Cadastro bem sucedido!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
        
		CALL prc_usuario_login(p_email, p_senha, @idUsuarioLogin, @resultUsuarioLogin);
    
    END IF;
    
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualiza_usuario(
	IN p_id INT,
	IN p_foto VARCHAR(255),
	IN p_nome VARCHAR(150),
    IN p_email VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_telefone VARCHAR(20),
    OUT p_message JSON
) BEGIN 
	
    DECLARE data_hoje DATE;
    SET data_hoje = curdate();
    
    IF NOT EXISTS (
		SELECT 1
        FROM tb_usuario
        WHERE id = p_id
    ) THEN SET p_message = JSON_OBJECT(
		'status', FALSE,
		'status_code', 404,
		'message', 'Não foram encontrados dados de retorno!!!',
		'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
    );
	
    ELSEIF EXISTS (
		SELECT 1 
        FROM tb_usuario
        WHERE email = p_email AND id != p_id
    ) THEN SET p_message = JSON_OBJECT(
		'status', FALSE,
		'status_code', 409,
		'message', 'Existem dados de inserção já cadastrados no sistema!!!',
		'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
	);
	
	ELSE
	
		UPDATE tb_usuario SET
			foto = p_foto,
            nome = p_nome,
            email = p_email,
            data_nascimento = p_data_nascimento,
            telefone = p_telefone
		WHERE id = p_id;
            
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_usuario(p_id, @resultUsuario);
    
    END IF;
    
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_solicita_redefinicao_senha(
	
    IN p_email VARCHAR(255),
    OUT p_message JSON

) BEGIN 

	DECLARE data_hoje DATE;
    SET data_hoje = curdate();

	IF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE email = p_email) THEN
    
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
			'message', 'Requisição bem sucedida!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    END IF;
    
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualiza_senha_usuario(

	IN p_id INT,
	IN p_senha VARCHAR(255),
    OUT p_message JSON

) BEGIN
	
    DECLARE data_hoje DATE;
    SET data_hoje = curdate();
    
	IF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id) THEN
		
		SET p_message =JSON_OBJECT(
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
			
    ELSE
    
		UPDATE tb_usuario SET
			senha = p_senha
		WHERE id = p_id;
    
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_home(p_id, @resultHome);
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_deleta_usuario(
	
    IN p_id INT,
    IN p_senha VARCHAR(255),
	OUT p_message JSON 
    
) BEGIN
	
    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();
    
    IF NOT EXISTS (
		SELECT 1
        FROM tb_usuario
        WHERE id = p_id
    ) THEN SET p_message = JSON_OBJECT(
		'status', FALSE,
		'status_code', 404,
		'message', 'Não foram encontrados dados de retorno!!!',
		'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
    );
    
    ELSEIF (
		SELECT 1
        FROM tb_usuario
        WHERE id = p_id AND senha = p_senha
    ) THEN 
		
        DELETE FROM tb_usuario WHERE id = p_id AND senha = p_senha;
    
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Item deletado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    ELSE 
		
        SET p_message = JSON_OBJECT(
		'status', FALSE,
		'status_code', 401,
		'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
		'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
    );
    
    
    END IF;

END$$
    
DELIMITER ;

-- select @idUsuarioLogin;
-- select @resultUsuario;
-- select @resultUsuarioLogin;
-- select @resultHome;
-- select @resultCreateUser;
-- select @resultUpdateUser;
-- select @resultDeleteUser;