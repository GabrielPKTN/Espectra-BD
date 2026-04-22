-- CREATE DATABASE db_espectra;
USE db_espectra;

-- ----------------------------------
-- TABELAS
-- ----------------------------------

CREATE TABLE tb_responsavel(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(50) NOT NULL

);

CREATE TABLE tb_psicopedagogo(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
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

CREATE TABLE tb_tipo_aplicacao(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    alternativa varchar(40) NOT NULL
);


CREATE TABLE tb_tentativa(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    observacao VARCHAR(300),
    
    CONSTRAINT fk_tipo_aplicacao
    FOREIGN KEY (id_tipo_aplicacao)  REFERENCES tb_tipo_aplicacao(id)

);


