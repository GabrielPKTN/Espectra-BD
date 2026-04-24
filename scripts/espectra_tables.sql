 -- CREATE DATABASE db_espectra;
USE db_espectra;

-- ----------------------------------
-- TABELAS
-- ----------------------------------

CREATE TABLE tb_responsavel(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    foto VARCHAR(255) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(50) NOT NULL

);

CREATE TABLE tb_psicopedagogo(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    foto VARCHAR(255) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(150) NOT NULL
);

CREATE TABLE tb_serie_escolar(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    serie VARCHAR(25)
);

CREATE TABLE tb_grau_suporte(
		
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	grau INT NOT NULL
);

CREATE TABLE tb_paciente(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
 	nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    diagnostico VARCHAR(50),
    id_serie_escolar INT NOT NULL,
    id_grau_suporte INT NOT NULL,
    id_psicopedagogo INT NOT NULL,
    
    CONSTRAINT fk_serie_escolar
    FOREIGN KEY (id_serie_escolar) REFERENCES tb_serie_escolar(id),
    
    CONSTRAINT fk_grau_suporte
    FOREIGN KEY (id_grau_suporte)  REFERENCES tb_grau_suporte(id),
    
    CONSTRAINT fk_psicopedagogo
    FOREIGN KEY (id_psicopedagogo) REFERENCES tb_psicopedagogo(id)
    
);

CREATE TABLE tb_resposta_formulario(
		
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	alternativa VARCHAR(20)
);

CREATE TABLE tb_faixa_idade(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idade_min INT NOT NULL,
    idade_max INT NOT NULL
);

CREATE TABLE tb_status_atividade(

	id 	INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    status_atividade VARCHAR(20)
    
);

CREATE TABLE tb_habilidade(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(20) NOT NULL

);

CREATE TABLE tb_atividade(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_habilidade INT NOT NULL,
    id_status_atividade INT NOT NULL,
    id_paciente INT NOT NULL,
    
    CONSTRAINT fk_habilidade
    FOREIGN KEY (id_habilidade) REFERENCES tb_habilidade(id),
    
    CONSTRAINT fk_status_atividade
    FOREIGN KEY (id_status_atividade)  REFERENCES tb_status_atividade(id),
    
    CONSTRAINT fk_paciente
    FOREIGN KEY (id_paciente) REFERENCES tb_paciente(id)
    
    );    
    
CREATE TABLE tb_tipo_aplicacao(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    alternativa varchar(30) NOT NULL
);

CREATE TABLE tb_tentativa(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    resultado BOOLEAN NOT NULL,
    observacao VARCHAR(1500),
    data_tentativa DATE NOT NULL,
	id_tipo_aplicacao INT NOT NULL,
    id_atividade INT NOT NULL,
    
    
    CONSTRAINT fk_tipo_aplicacao
    FOREIGN KEY (id_tipo_aplicacao)  REFERENCES tb_tipo_aplicacao(id),
    
	CONSTRAINT fk_atividade
    FOREIGN KEY (id_atividade)  REFERENCES tb_atividade(id)

);

CREATE TABLE tb_atividade_personalizada(

	id 	INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    questao VARCHAR(300) NOT NULL,
    valor_meses INT NOT NULL,
    id_psicopedagogo INT NOT NULL,
    id_atividade INT NOT NULL,
    
    CONSTRAINT fk_psicopedagogo_atividade_personalizada
    FOREIGN KEY (id_psicopedagogo)  REFERENCES tb_psicopedagogo(id),
    
	CONSTRAINT fk_atividade_atividade_personalizada
    FOREIGN KEY (id_atividade)  REFERENCES tb_atividade(id)
    
);

CREATE TABLE tb_responsavel_paciente(
		
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		id_responsavel INT NOT NULL,
		id_paciente INT NOT NULL,
        
        CONSTRAINT fk_responsavel_responsavel_paciente
		FOREIGN KEY (id_responsavel) REFERENCES tb_responsavel(id),
        
		CONSTRAINT fk_paciente_responsavel_paciente
		FOREIGN KEY (id_paciente) REFERENCES tb_paciente(id)
    );
    
CREATE TABLE tb_atividade_portage(
		
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        numero_questao INT NOT NULL,
        questao VARCHAR(300) NOT NULL,
        id_faixa_idade INT NOT NULL,
		id_atividade INT NOT NULL,
        
        
		CONSTRAINT fk_faixa_idade_atividade_portage
		FOREIGN KEY (id_faixa_idade) REFERENCES tb_faixa_idade(id),
    
		CONSTRAINT fk_atividade_atividade_portage
		FOREIGN KEY (id_atividade) REFERENCES tb_atividade(id)
        
    );

CREATE TABLE tb_formulario(
		
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        id_paciente INT NOT NULL,
		id_atividade_portage INT NOT NULL,
        id_resposta INT NOT NULL,
	
        
        CONSTRAINT fk_paciente_formulario
		FOREIGN KEY (id_paciente)  REFERENCES tb_paciente(id),
    
		CONSTRAINT fk_atividade_portage_formulario
		FOREIGN KEY (id_atividade_portage)  REFERENCES tb_atividade_portage(id),
        
        CONSTRAINT fk_resposta_formulario
		FOREIGN KEY (id_resposta)  REFERENCES tb_resposta_formulario(id)
    
    );
    
CREATE TABLE tb_paciente_habilidade(
		
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        anos_meses DECIMAL(10,1) NOT NULL,
        id_paciente INT NOT NULL,
		id_habilidade INT NOT NULL,
        
        
        CONSTRAINT fk_paciente_paciente_habilidade
		FOREIGN KEY (id_paciente)  REFERENCES tb_paciente(id),
    
		CONSTRAINT fk_habilidade_paciente_habilidade
		FOREIGN KEY (id_habilidade)  REFERENCES tb_habilidade(id)
        
    
    );
    