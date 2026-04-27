-- ----------------------------------
-- PROCEDURES
-- ----------------------------------


-- ADICIONAR PSICOPEDAGOGO

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

-- Quando a procedure for usada no Back-End deve ser chamada dessa maneira, o SELECT na mensagem já retorna um JSON com os dados cadastrados.
call procedure_adicionar_psicopedagogo('foto.png', 'Enzo Carrilho', '2005-09-25', '(11)95978-8007', 'enzo@email.com', '123456', @msg);
SELECT @msg;

