-- ----------------------------------
-- PROCEDURES
-- ----------------------------------

-- PROCEDURE QUE ATUALIZA O PERFIL DO PSICOPEDAGOGO
delimiter $$
CREATE PROCEDURE proc_atualizar_psicopedagogo(
	IN psic_id INT,
    IN psic_foto VARCHAR(255),
    IN psic_nome VARCHAR(150),
    IN psic_data_nascimento DATE,
    IN psic_telefone VARCHAR(20)
)
BEGIN
	DECLARE id_existe INT;
    
    SELECT COUNT(*) INTO id_existe 
    FROM tb_psicopedagogo WHERE id = psic_id;
    
    if id_existe > 0 THEN
		UPDATE tb_psicopedagogo 
        SET 
			foto = psic_foto,
			nome = psic_nome,
			data_nascimento = psic_data_nascimento,
			telefone = psic_telefone
		WHERE id = psic_id;
        
        SELECT "Atualizado com Sucesso!" as mensagem;
	ELSE
		SELECT CONCAT('O ID', psic_id, 'NÃO EXISTE!') as erro404;
	END IF;
end $$
delimiter ;

CALL proc_atualizar_psicopedagogo(
	1, -- Id do Psicopedagogo
    'psico1.jpg', -- Foto do Psicopedagogo
    'Nicolas', -- Nome do Psicopedagogo
    '2008-06-16', -- Data de nascimento do Psicopedagogo
    '(11) 96666-6666' -- Telefone do Psicopedagogo
);

-- PROCEDURE QUE ATUALIZA A SENHA DO PSICOPEDAGOGO
DELIMITER $$
CREATE PROCEDURE proc_atualizar_senha_psicopedagogo(
	IN psic_id INT, 
    IN psic_email VARCHAR(255),
    IN psic_nova_senha VARCHAR(150)
)
BEGIN
	DECLARE id_existe INT;

	SELECT COUNT(*) INTO id_existe
	FROM tb_psicopedagogo
	WHERE id = psic_id AND email = psic_email;

	IF id_existe > 0 THEN
		UPDATE tb_psicopedagogo
        SET senha = psic_nova_senha
        WHERE id = psic_id AND email = psic_email;
        
        SELECT 'Senha atualizada com sucesso!' AS mensagem;
        
	ELSE
		SELECT CONCAT('ID ou email inválido (ID: ', psic_id, ')') AS erro;
        
	END IF;
END $$
DELIMITER ;

CALL proc_atualizar_senha_psicopedagogo(
	1, -- Id do Psicopedagogo
    'ana.martins@email.com', -- Email do psicopedagogo
    'senhaN0103' -- Senha nova do psicopedagogo
)

-- PROCEDURE PARA DELETAR PSICOPEDAGOGO
DELIMITER $$
CREATE PROCEDURE proc_delete_psicopedagogo(
	IN psic_id INT
)
BEGIN
	DECLARE id_existe INT;
    
    SELECT COUNT(*) INTO id_existe
    FROM tb_psicopedagogo WHERE id = psic_id;
    
    IF id_existe > 0 THEN
		DELETE FROM tb_psicopedagogo WHERE id = psic_id;
        SELECT ("Perfil deletado com sucesso") AS mensagem;
	ELSE
		SELECT CONCAT("O ID	", psic_id, "	NÃO EXISTE!") as erro;
	END IF;
END $$
DELIMITER ;

CALL proc_delete_psicopedagogo(
	1
);