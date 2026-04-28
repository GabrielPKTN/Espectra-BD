-- ----------------------------------
-- TRIGGERS
-- ----------------------------------

-- Trigger para deletar relações de psicopedagogo
DELIMITER $$
CREATE TRIGGER trg_delete_relacoes_psicopedagogo
BEFORE DELETE ON tb_psicopedagogo
FOR EACH ROW
BEGIN
	DELETE FROM tb_tentativa
	WHERE id_atividade IN (
		SELECT a.id
		FROM tb_atividade a
		JOIN tb_paciente p ON a.id_paciente = p.id
		WHERE p.id_psicopedagogo = OLD.id
	);

	DELETE FROM tb_atividade
	WHERE id_paciente IN (
		SELECT id FROM tb_paciente 
		WHERE id_psicopedagogo = OLD.id
	);

	DELETE FROM tb_formulario
	WHERE id_paciente IN (
		SELECT id FROM tb_paciente 
		WHERE id_psicopedagogo = OLD.id
	);

	DELETE FROM tb_paciente_habilidade
	WHERE id_paciente IN (
		SELECT id FROM tb_paciente 
		WHERE id_psicopedagogo = OLD.id
	);

	DELETE FROM tb_atividade_personalizada
	WHERE id_psicopedagogo = OLD.id;

	UPDATE tb_paciente
	SET id_psicopedagogo = NULL
	WHERE id_psicopedagogo = OLD.id;
END$$
DELIMITER ; 