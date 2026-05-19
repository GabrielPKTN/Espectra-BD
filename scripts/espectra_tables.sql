CREATE DATABASE db_espectra;
USE db_espectra;

-- Usuario
CREATE TABLE tb_tipo_usuario(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    tipo_usuario VARCHAR(40) NOT NULL

);

CREATE TABLE tb_usuario(
	
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    foto VARCHAR(255) NULL,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    id_tipo_usuario INT NOT NULL,
    
    CONSTRAINT fk_tipo_usuario_usuario
    FOREIGN KEY (id_tipo_usuario) REFERENCES tb_tipo_usuario(id)
    
);

-- Paciente
CREATE TABLE tb_sigla_transtorno(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    sigla VARCHAR(20) NOT NULL,
    nome_completo_transtorno VARCHAR(100) NOT NULL

);

CREATE TABLE tb_serie_escolar(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    serie VARCHAR(30) NOT NULL
    
);

CREATE TABLE tb_grau_suporte(
		
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	grau VARCHAR(30) NOT NULL
    
);

CREATE TABLE tb_paciente(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    foto VARCHAR(255) NULL,
    cpf VARCHAR(20) NOT NULL,
 	nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    id_serie_escolar INT NOT NULL,
    id_grau_suporte INT NOT NULL,
    id_usuario INT NOT NULL,
    
    CONSTRAINT fk_serie_escolar_paciente
    FOREIGN KEY (id_serie_escolar) REFERENCES tb_serie_escolar(id),
    
    CONSTRAINT fk_grau_suporte_paciente
    FOREIGN KEY (id_grau_suporte)  REFERENCES tb_grau_suporte(id),
    
    CONSTRAINT fk_usuario_paciente
    FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id)
    
);

CREATE TABLE tb_paciente_transtorno(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_paciente INT NOT NULL,
    id_sigla_transtorno INT NOT NULL,
    
    CONSTRAINT fk_paciente_paciente_transtorno
    FOREIGN KEY (id_paciente) REFERENCES tb_paciente(id),
    
    CONSTRAINT fk_sigla_transtorno_paciente_transtorno
    FOREIGN KEY (id_sigla_transtorno) REFERENCES tb_sigla_transtorno(id)
    

);


-- Paciente & Usuario
CREATE TABLE tb_usuario_paciente(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_usuario INT NOT NULL,
    id_paciente INT NOT NULL,
    
    CONSTRAINT fk_usuario_usuario_paciente
    FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
    
    CONSTRAINT fk_paciente_usuario_paciente
    FOREIGN KEY (id_paciente) REFERENCES tb_paciente(id)

);


-- Habilidade
CREATE TABLE tb_habilidade(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(50) NOT NULL

);


-- Habilidade & Paciente
CREATE TABLE tb_paciente_habilidade(
		
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	idade_meses DECIMAL(10,4) NOT NULL,
	id_paciente INT NOT NULL,
	id_habilidade INT NOT NULL,
	
	
	CONSTRAINT fk_paciente_paciente_habilidade
	FOREIGN KEY (id_paciente)  REFERENCES tb_paciente(id),

	CONSTRAINT fk_habilidade_paciente_habilidade
	FOREIGN KEY (id_habilidade)  REFERENCES tb_habilidade(id)
        
);

-- Atividade
CREATE TABLE tb_faixa_idade(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idade_min INT NOT NULL,
    idade_max INT NOT NULL,
    valor_atividade DECIMAL(10, 4) NOT NULL
    
);

CREATE TABLE tb_atividade_personalizada(

	id 	INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    comportamento VARCHAR(300) NOT NULL,
    valor_meses INT NOT NULL,
    id_habilidade INT NOT NULL,
    id_usuario INT NOT NULL,
    
    CONSTRAINT fk_usuario_atividade_personalizada
    FOREIGN KEY (id_usuario)  REFERENCES tb_usuario(id),
    
	CONSTRAINT fk_habilidade_atividade_personalizada
    FOREIGN KEY (id_habilidade)  REFERENCES tb_habilidade(id)
    
);

CREATE TABLE tb_atividade_portage(
		
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	numero_questao INT NOT NULL,
	comportamento VARCHAR(300) NOT NULL,
	id_faixa_idade INT NOT NULL,
	id_habilidade INT NOT NULL,
	
	
	CONSTRAINT fk_faixa_idade_atividade_portage
	FOREIGN KEY (id_faixa_idade) REFERENCES tb_faixa_idade(id),

	CONSTRAINT fk_habilidade_atividade_portage
	FOREIGN KEY (id_habilidade) REFERENCES tb_habilidade(id)
        
);

CREATE TABLE tb_atividade(
	
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    concluida BOOLEAN NOT NULL DEFAULT FALSE,
    id_paciente INT NOT NULL,
    id_atividade_personalizada INT NULL,
    id_atividade_portage INT NULL,
    
    CONSTRAINT fk_paciente_atividade
    FOREIGN KEY (id_paciente) REFERENCES tb_paciente(id),
    
    CONSTRAINT fk_atividade_personalizada_atividade
    FOREIGN KEY (id_atividade_personalizada) REFERENCES tb_atividade_personalizada(id),
    
    CONSTRAINT fk_atividade_portage_atividade
    FOREIGN KEY (id_atividade_portage) REFERENCES tb_atividade_portage(id)
    
);


-- Tentativa
CREATE TABLE tb_tipo_aplicacao(	

    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    alternativa varchar(30) NOT NULL
    
);

CREATE TABLE tb_tentativa(

	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    resultado BOOLEAN NOT NULL,
	data_tentativa DATE NOT NULL,
    observacao TEXT NULL,
	id_tipo_aplicacao INT NOT NULL,
    id_atividade INT NOT NULL,
    
    
    CONSTRAINT fk_tipo_aplicacao_tentativa
    FOREIGN KEY (id_tipo_aplicacao)  REFERENCES tb_tipo_aplicacao(id),
    
	CONSTRAINT fk_atividade_tentativa
    FOREIGN KEY (id_atividade)  REFERENCES tb_atividade(id)

);


-- Formulario
CREATE TABLE tb_resposta_formulario(
		
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	alternativa VARCHAR(30) NOT NULL
     
);

CREATE TABLE tb_formulario(
		
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        id_paciente INT NOT NULL,
		id_atividade_portage INT NOT NULL,
        id_resposta INT NULL,
	
        
        CONSTRAINT fk_paciente_formulario
		FOREIGN KEY (id_paciente)  REFERENCES tb_paciente(id),
    
		CONSTRAINT fk_atividade_portage_formulario
		FOREIGN KEY (id_atividade_portage)  REFERENCES tb_atividade_portage(id),
        
        CONSTRAINT fk_resposta_formulario
		FOREIGN KEY (id_resposta)  REFERENCES tb_resposta_formulario(id)
    
    );
    