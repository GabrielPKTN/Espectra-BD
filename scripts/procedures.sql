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


-- ADICIONAR PACIENTE

DELIMITER $$

CREATE PROCEDURE procedure_adicionar_paciente(
    IN p_nome VARCHAR(150),
    IN p_foto VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_diagnostico VARCHAR(50),
    IN p_id_serie_escolar INT,
    IN p_id_grau_suporte INT,
    IN p_id_responsavel INT,
    OUT p_mensagem JSON
)
BEGIN

    DECLARE grau_suporte INT;
    DECLARE serie_escolar VARCHAR(50);
    DECLARE v_numero_registro VARCHAR(20);
    
    DECLARE v_habilidades JSON;
    DECLARE v_responsaveis JSON;

    DECLARE novo_id INT;
    DECLARE idade INT;

    -- HABILIDADE
    DECLARE id_habilidade INT;
    DECLARE nome_habilidade VARCHAR(25);
    DECLARE valor_meses DECIMAL(10,1);

    -- PSICOPEDAGOGO
    DECLARE id_psicopedagogo INT;
    DECLARE nome_psicopedagogo VARCHAR(150);
    DECLARE telefone_psicopedagogo VARCHAR(20);

    -- RESPONSAVEL
    DECLARE id_responsavel INT;
    DECLARE nome_responsavel VARCHAR(150);
    DECLARE telefone_responsavel VARCHAR(20);

    
    IF EXISTS (SELECT 1 FROM tb_paciente WHERE nome = p_nome) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'message', 'Este paciente já existe',
            'data', NULL
        );

    ELSE

        
        -- GERA NUMERO DE REGISTRO
        SELECT CONCAT(
            DATE_FORMAT(NOW(), '%Y%m'),
            LPAD(
                IFNULL(MAX(SUBSTRING(numero_registro, 7, 4)), 0) + 1,
                4,
                '0'
            )
        )
        INTO v_numero_registro
        FROM tb_paciente
        WHERE numero_registro LIKE CONCAT(DATE_FORMAT(NOW(), '%Y%m'), '%');

      
        -- INSERT PACIENTE
        INSERT INTO tb_paciente(
            numero_registro,
            nome,
            foto,
            data_nascimento,
            diagnostico,
            id_serie_escolar,
            id_grau_suporte
        )
        VALUES (
            v_numero_registro,
            p_nome,
            p_foto,
            p_data_nascimento,
            p_diagnostico,
            p_id_serie_escolar,
            p_id_grau_suporte
        );

        SET novo_id = LAST_INSERT_ID();

        -- RESPONSAVEL
        INSERT INTO tb_responsavel_paciente(id_responsavel, id_paciente)
        VALUES (p_id_responsavel, novo_id);

        -- IDADE (CORRIGIDA)
        SET idade = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());

        -- GRAU
        SELECT grau.grau
        INTO grau_suporte
        FROM tb_paciente paciente
        JOIN tb_grau_suporte grau ON paciente.id_grau_suporte = grau.id
        WHERE paciente.id = novo_id
        LIMIT 1;

        -- SERIE
        SELECT serie.serie
        INTO serie_escolar
        FROM tb_paciente paciente
        JOIN tb_serie_escolar serie ON paciente.id_serie_escolar = serie.id
        WHERE paciente.id = novo_id
        LIMIT 1;

	
        -- DEFININDO HABILIDADES
        SELECT JSON_ARRAYAGG(
			JSON_OBJECT(
				'id', h.id,
				'nome', h.nome,
				'valor_meses', ph.anos_meses
			)
		)
		INTO v_habilidades
		FROM tb_habilidade h
		JOIN tb_paciente_habilidade ph 
			ON h.id = ph.id_habilidade
		WHERE ph.id_paciente = novo_id;
        
        -- DEFININDO PSICOPEDAGOGO
        SELECT
            psicopedagogo.id,
            psicopedagogo.nome,
            psicopedagogo.telefone
		INTO 
			id_psicopedagogo,
            nome_psicopedagogo,
            telefone_psicopedagogo
        FROM tb_psicopedagogo psicopedagogo JOIN tb_paciente paciente ON psicopedagogo.id = paciente.id_psicopedagogo
        WHERE paciente.id = novo_id;
        
        -- DEFININDO RESPONSÁVEIS
        SELECT JSON_ARRAYAGG(
			JSON_OBJECT(
				'id', r.id,
				'nome', r.nome,
				'telefone', r.telefone
			)
		)
		INTO v_responsaveis
		FROM tb_responsavel r
		JOIN tb_responsavel_paciente rp 
			ON r.id = rp.id_responsavel
		WHERE rp.id_paciente = novo_id;
        
     

        -- JSON FINAL
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Paciente cadastrado com sucesso',
            'data', JSON_OBJECT(
                'nome', p_nome,
                'foto', p_foto,
                'data_nascimento', p_data_nascimento,
                'idade', idade,
                'diagnostico', p_diagnostico,
                'serie_escolar', serie_escolar,
                'grau_suporte', grau_suporte,
                'numero_registro', v_numero_registro,

                'grafico', v_habilidades,

                'psicopedagogo', JSON_ARRAY(
                    JSON_OBJECT(
                        'id', id_psicopedagogo,
                        'nome', nome_psicopedagogo,
                        'telefone', telefone_psicopedagogo
                    )
                ),

                'responsavel', v_responsaveis
            )
        );

    END IF;

END $$

DELIMITER ;



