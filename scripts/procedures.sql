-- ----------------------------------
-- PROCEDURES
-- ----------------------------------

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
	1, 
    'psico1.jpg',
    'Nicolas',
    '2008-06-16',
    '(11) 96666-6666'
);