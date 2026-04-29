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

-- Desativa temporariamente o Safe Updates
SET SQL_SAFE_UPDATES = 0;

CALL proc_delete_psicopedagogo(
	1 -- Id Psicopedagogo
);

-- PROCEDURE PARA ATUALIZAR FORMULÁRIO
DELIMITER $$
CREATE PROCEDURE proc_atualizar_respostas_formulario(
	IN form_id INT,
    IN form_atividade_portage INT,
    IN form_resposta INT
)
BEGIN 
	DECLARE id_existe INT;
    
    SELECT COUNT(*) INTO id_existe
    FROM tb_formulario WHERE id = form_id 
	AND id_atividade_portage = form_atividade_portage;
    
    IF id_existe > 0 THEN
		UPDATE tb_formulario
        SET
			id_resposta = form_resposta
		WHERE id = form_id AND id_atividade_portage = form_atividade_portage;
        
        SELECT "Formulário atualizado com sucesso!" as mensagem;
	ELSE
		SELECT CONCAT("Registro não encontrado (ID: ", form_id, ")") as erro;
	END IF;
END $$
DELIMITER ;

CALL proc_atualizar_respostas_formulario(
	2, -- Id do Formulário
    2, -- Id da Pergunta (Portage)
    3 -- Id da Resposta
);

-- PROCEDURE PARA INSERIR ATIVIDADE PORTAGE
DELIMITER $$
CREATE PROCEDURE proc_inserir_atividade_tipo_portage(
	IN portage_id_status_atividade INT,
    IN portage_id_paciente INT,
    IN portage_id INT
)
BEGIN
	DECLARE paciente_existe INT;
    
    SELECT COUNT(*) INTO paciente_existe
    FROM tb_paciente WHERE id = portage_id_paciente;
    
    IF paciente_existe > 0 THEN

		INSERT INTO tb_atividade (id_status_atividade, id_paciente, id_atividade_portage)
		VALUES (
				portage_id_status_atividade,
				portage_id_paciente,
				portage_id
		);
		SELECT "Atividade criada com sucesso!" as mensagem;
	ELSE
		SELECT "Paciente não encontrado!" as erro;
	END IF;
END$$
DELIMITER ;

CALL proc_inserir_atividade_tipo_portage(
		1, -- Id do Status da Atividade
        1, -- Id do Paciente
        1 -- Id da Atividade Portage
);