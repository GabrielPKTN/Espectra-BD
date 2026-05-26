DELIMITER $$

CREATE TRIGGER trg_deleta_tentativas_atividade
BEFORE DELETE ON tb_atividade
FOR EACH ROW
BEGIN
    
    DELETE FROM tb_tentativa WHERE id_atividade = OLD.id;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_deleta_atividade_personalizada_atividade
AFTER DELETE ON tb_atividade
FOR EACH ROW
BEGIN
    
    IF (OLD.id_atividade_personalizada IS NOT NULL) THEN
    
    DELETE FROM tb_atividade_personalizada WHERE id = OLD.id_atividade_personalizada;
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_atividade_status
AFTER UPDATE ON tb_atividade
FOR EACH ROW

BEGIN

    IF (OLD.concluida = 0 AND NEW.concluida = 1) THEN

        -- Verifica se é uma atividade do tipo personalizada
        IF (OLD.id_atividade_personalizada IS NOT NULL) THEN

            -- Caso seja atualiza o valor somando o valor da atividade personalizada
            UPDATE tb_paciente_habilidade SET
                idade_meses = idade_meses + ( -- Soma com o valor da 

                    SELECT valor_meses FROM tb_atividade_personalizada
                    WHERE id = OLD.id_atividade_personalizada

                )
            WHERE id_paciente = OLD.id_paciente
            AND id_habilidade = (
                
                SELECT id_habilidade 
                FROM tb_atividade_personalizada 
                WHERE id = OLD.id_atividade_personalizada
                
                );

        END IF;

    END IF;

END$$

DELIMITER ;