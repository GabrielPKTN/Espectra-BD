
drop trigger trg_update_idade_formulario;
DELIMITER $$

CREATE TRIGGER trg_update_idade_formulario
AFTER UPDATE ON tb_formulario
FOR EACH ROW
BEGIN
	
    -- SE ATUALIZADO PARA SIM
	IF (NEW.id_resposta = 1 AND (OLD.id_resposta IS NULL OR OLD.id_resposta = 2 OR OLD.id_resposta = 3)) THEN
		
        -- VERIFICA SE TEM UMA ATIVIDADE COM ESSE ID DE ATIVIDADE PORTAGE
		IF EXISTS (
			SELECT 1 FROM tb_atividade WHERE id_atividade_portage = OLD.id_atividade_portage
        ) THEN
        
			-- SE TIVER, MARCA COMO CONCLUÍDA
			UPDATE tb_atividade SET
				concluida = TRUE
			WHERE id_atividade_portage = OLD.id_atividade_portage
            AND concluida = FALSE;
		
        ELSE
			
            -- SE NÃO INSERE UMA CONCLUÍDA
			INSERT INTO tb_atividade(
				concluida,
                id_paciente,
                id_atividade_portage
            ) VALUES (
				TRUE,
                OLD.id_paciente,
				OLD.id_atividade_portage
            );
        
	END IF;
		
        -- ATUALIZA O VALOR DA IDADE EM MESES NA TABELA HABILIDADE_PACIENTE (GRÁFICO)
		UPDATE tb_paciente_habilidade
        SET idade_meses = idade_meses + (
			SELECT
				valor_atividade
            FROM tb_faixa_idade
            JOIN tb_atividade_portage ON
            tb_atividade_portage.id_faixa_idade = tb_faixa_idade.id
            WHERE tb_atividade_portage.id = OLD.id_atividade_portage
        ) WHERE id_paciente = OLD.id_paciente
			AND id_habilidade = (SELECT id_habilidade FROM tb_atividade_portage WHERE id = OLD.id_atividade_portage);
        
	-- CASO A RESPOSTA TENHA SIDO "NÃO" OU "SIM, COM MEDIAÇÃO"
	ELSEIF (NEW.id_resposta = 2 OR NEW.id_resposta = 3) THEN
    
		-- ELE VERIFICA SE ANTERIORMENTE A RESPOSTA ESTAVA MARCADA COMO SIM E SUBTRAI O VALOR DESSA ATIVIDADE PORTAGE
		IF(OLD.id_resposta = 1) THEN
        
			UPDATE tb_paciente_habilidade
			SET idade_meses = idade_meses - (
				SELECT
					valor_atividade
				FROM tb_faixa_idade
				JOIN tb_atividade_portage ON
				tb_atividade_portage.id_faixa_idade = tb_faixa_idade.id
				WHERE tb_atividade_portage.id = OLD.id_atividade_portage
			) WHERE id_paciente = OLD.id_paciente
				AND id_habilidade = (SELECT id_habilidade FROM tb_atividade_portage WHERE id = OLD.id_atividade_portage);
                
			-- VERIFICA SE TEM UMA ATIVIDADE COM ESSE ID DE ATIVIDADE PORTAGE MARCADA COMO CONCLUIDA NO BANCO
			IF EXISTS(SELECT 1 FROM tb_atividade WHERE id_atividade_portage = OLD.id_atividade_portage AND CONCLUIDA = 1) THEN
				
				-- CASO TENHA, ELE DEFINE ELA COMO NÃO CONCLUIDA PARA DESENVOLVER
				UPDATE tb_atividade SET
					concluida = FALSE
				WHERE id_atividade_portage = OLD.id_atividade_portage
                AND concluida = TRUE;
				
			END IF;
        
        END IF;
    
    END IF;

END$$

DELIMITER ;