DELIMITER $$

CREATE TRIGGER trg_habilidade_paciente
AFTER INSERT ON tb_paciente
FOR EACH ROW
BEGIN

	INSERT INTO tb_paciente_habilidade(id_paciente, id_habilidade, idade_meses) VALUES
    (NEW.id, 1, 0.0),
    (NEW.id, 2, 0.0),
    (NEW.id, 3, 0.0),
    (NEW.id, 4, 0.0),
    (NEW.id, 5, 0.0);

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_formulario_paciente
AFTER INSERT ON tb_paciente
FOR EACH ROW
BEGIN
    
	INSERT INTO tb_formulario(id_paciente, id_atividade_portage, id_resposta)
    SELECT NEW.id, id, NULL
    FROM tb_atividade_portage
    ORDER BY id ASC;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_delete_diagnostico_paciente
BEFORE UPDATE ON tb_paciente
FOR EACH ROW
BEGIN

	DELETE FROM tb_paciente_transtorno WHERE id_paciente = OLD.id;

END $$

DELIMITER ;