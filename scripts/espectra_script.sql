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
    
-- ----------------------------------
-- INSERTS
-- ----------------------------------
USE db_espectra;


INSERT INTO tb_tipo_usuario(tipo_usuario) VALUES ('Psicopedagogo'),('Responsável');


INSERT INTO tb_usuario (foto, nome, data_nascimento, telefone, email, senha, id_tipo_usuario) VALUES
(NULL, 'Gabriel Lacerda Correia', '2005-08-09', '(11) 92479-2057', 'gabriel@email.com', '123456@ABC', 1),
(NULL, 'Maria Cecília Pereira Jardim', '2008-03-21', '(11) 95324-6654', 'maria@email.com', '654321@CBA', 2);


INSERT INTO tb_serie_escolar (serie) VALUES
('MATERNAL'),
('JARDIM I'),
('JARDIM II'),
('1º ANO'),
('2º ANO'),
('3º ANO'),
('4º ANO'),
('5º ANO'),
('6º ANO'),
('7º ANO'),
('8º ANO'),
('9º ANO'),
('1º MÉDIO'),
('2º MÉDIO'),
('3º MÉDIO'),
('CONCLUIDO');


INSERT INTO tb_grau_suporte (grau) VALUES
('GRAU 1'),
('GRAU 2'),
('GRAU 3');


INSERT INTO tb_paciente (foto, nome, cpf, data_nascimento, id_serie_escolar, id_grau_suporte, id_usuario) VALUES
(NULL, 'Lucas Andrade', '68212059812', '2015-04-10', 4, 1, 1),
(NULL, 'Beatriz Oliveira', '75287318898', '2013-09-22', 6, 2, 1),
(NULL, 'Pedro Santos', '71121093884', '2011-01-30', 8, 1, 1),
(NULL, 'Juliana Costa', '50773850848', '2016-07-15', 3, 2, 2),
(NULL, 'Rafael Mendes', '50805139850', '2010-12-05', 9, 3, 2);

INSERT INTO tb_usuario_paciente (id_paciente, id_usuario) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(1, 2),
(2, 2),
(3, 2),
(4, 2),
(5, 2);

INSERT INTO tb_sigla_transtorno (sigla, nome_completo_transtorno) VALUES
('TDAH', 'Transtorno do Déficit de Atenção com Hiperatividade'),
('TEA', 'Transtorno do Espectro Autista'),
('TAG', 'Transtorno de Ansiedade Generalizada'),
('TAB', 'Transtorno Afetivo Bipolar'),
('TOC', 'Transtorno Obsessivo-Compulsivo'),
('TEPT', 'Transtorno de Estresse Pós-Traumático'),
('TPL', 'Transtorno de Personalidade Borderline'),
('TOD', 'Transtorno Opositor Desafiador'),
('TDC', 'Transtorno Dismórfico Corporal'),
('TCA', 'Transtorno de Compulsão Alimentar'),
('TDA', 'Transtorno do Déficit de Atenção'),
('TPAS', 'Transtorno da Personalidade Antissocial'),
('TPN', 'Transtorno de Personalidade Narcisista'),
('TPE', 'Transtorno de Personalidade Esquizoide'),
('TP Esquizo', 'Transtorno de Personalidade Esquizotípica'),
('TPE-Evit', 'Transtorno de Personalidade Evitativa'),
('TPD', 'Transtorno de Personalidade Dependente'),
('TP Histri', 'Transtorno de Personalidade Histriônica'),
('T Pânico', 'Transtorno de Pânico'),
('TAS', 'Transtorno de Ansiedade Social'),
('Fob. Esp.', 'Fobia Específica'),
('Agorafob', 'Agorafobia'),
('T. Depr. M', 'Transtorno Depressivo Maior'),
('Distimia', 'Transtorno Depressivo Persistente'),
('T. Somat', 'Transtorno de Sintomas Somáticos'),
('T. Convers', 'Transtorno Conversivo'),
('T. Factíc', 'Transtorno Factício'),
('Anorexia', 'Anorexia Nervosa'),
('Bulimia', 'Bulimia Nervosa'),
('Insônia', 'Transtorno de Insônia'),
('Hipersônia', 'Transtorno de Hipersônia'),
('Narcolep', 'Narcolepsia'),
('Apneia', 'Apneia Obstrutiva do Sono'),
('Dislexia', 'Transtorno Específico de Aprendizagem com prejuízo na leitura'),
('Discalc', 'Transtorno Específico de Aprendizagem com prejuízo na matemática'),
('Tiques', 'Transtorno de Tiques'),
('Tourette', 'Transtorno de Tourette'),
('Esquizof', 'Esquizofrenia'),
('T. Esquizoa', 'Transtorno Esquizoafetivo'),
('T. Delir', 'Transtorno Delirante');


INSERT INTO tb_paciente_transtorno (id_paciente, id_sigla_transtorno) VALUES
-- Paciente 1 com TDAH e TEA
(1, 1), 
(1, 2),

-- Paciente 2 com TAG e TOC
(2, 3),
(2, 5);


INSERT INTO tb_resposta_formulario (alternativa) VALUES
('Sim'),
('Não'),
('Sim com mediação');



INSERT INTO tb_faixa_idade (idade_min, idade_max, valor_atividade) VALUES
(0, 1, 0.0089),
(1, 2, 0.0128),
(2, 3, 0.0086),
(3, 4, 0.0121),
(4, 5, 0.0109),
(5, 6, 0.0098);


INSERT INTO tb_habilidade (nome) VALUES
('Socialização'),
('Linguagem'),
('Cognição'),
('Auto-Cuidados'),
('Desenvolvimento motor');

INSERT INTO tb_paciente_habilidade (idade_meses, id_paciente, id_habilidade) VALUES
(0.0, 1, 1),
(0.0, 1, 2),
(0.0, 1, 3),
(0.0, 1, 4),
(0.0, 1, 5),
(0.0, 2, 1),
(0.0, 2, 2),
(0.0, 2, 3),
(0.0, 2, 4),
(0.0, 2, 5),
(0.0, 3, 1),
(0.0, 3, 2),
(0.0, 3, 3),
(0.0, 3, 4),
(0.0, 3, 5),
(0.0, 4, 1),
(0.0, 4, 2),
(0.0, 4, 3),
(0.0, 4, 4),
(0.0, 4, 5),
(0.0, 5, 1),
(0.0, 5, 2),
(0.0, 5, 3),
(0.0, 5, 4),
(0.0, 5, 5);


INSERT INTO tb_atividade_personalizada (comportamento, valor_meses, id_usuario, id_habilidade) VALUES
('Estende a mão em direção a um objeto oferecido', 1, 1, 1),
('Segue com o olhar um objeto em movimento', 1, 1, 1),
('Responde ao ser chamado pelo nome', 1, 1, 1),
('Imita gestos simples como bater palmas', 1, 1, 1),
('Segura objetos pequenos com as mãos', 2, 1, 1);


INSERT INTO tb_atividade_portage (numero_questao, comportamento, id_faixa_idade, id_habilidade) VALUES
(1, 'Observa uma pessoa movimentando-se em seu campo visual.', 1, 1),
(2, 'Sorri em resposta à atenção do adulto.', 1, 1),
(3, 'Vocaliza em resposta à atenção.', 1, 1),
(4, 'Olha para sua própria mão, sorrindo ou vocalizando.', 1, 1),
(5, 'Responde a seu círculo familiar, sorrindo, vocalizando ou parando de chorar.', 1, 1),
(6, 'Sorri em resposta à expressão facial dos outros.', 1, 1),
(7, 'Sorri e vocaliza ao ver sua imagem no espelho', 1, 1),
(8, 'Acaricia ou toca no rosto de adultos (puxa cabelo, nariz, óculos, etc.).', 1, 1),
(9, 'Estende a mão em direção a um objeto oferecido.', 1, 1),
(10, 'Estende os braços em direção a pessoas familiares.', 1, 1),
(11, 'Estende a mão e toca sua imagem refletida no espelho.', 1, 1),
(12, 'Segura e examina por 1 minuto um objeto que lhe foi dado.', 1, 1),
(13, 'Sacode ou aperta um objeto colocado em sua mão, produzindo sons involuntários.', 1, 1),
(14, 'Brinca sozinho por 10 minutos.', 1, 1),
(15, 'Procura contato visual quando alguém lhe dá atenção por 2 a 3 minutos.', 1, 1),
(16, 'Brinca sozinho sem reclamar por 15 a 20 minutos, próximo de um adulto.', 1, 1),
(17, 'Vocaliza para obter atenção.', 1, 1),
(18, 'Imita adulto em brincadeiras de esconde-esconde.', 1, 1),
(19, 'Bate palmas, imitando um adulto.', 1, 1),
(20, 'Acena a mão, imitando um adulto.', 1, 1),
(21, 'Ergue os braços para expressar "grande", imitando um adulto.', 1, 1),
(22, 'Oferece algo, mas nem sempre entrega.', 1, 1),
(23, 'Abraça, acaricia e beija familiares.', 1, 1),
(24, 'Responde ao próprio nome, olhando ou estendendo o braço para ser pego.', 1, 1),
(25, 'Aperta ou sacode um brinquedo para produzir sons, em imitação.', 1, 1),
(26, 'Manipula brinquedo ou objeto.', 1, 1),
(27, 'Estende um brinquedo ou objeto a um adulto e o entrega.', 1, 1),
(28, 'Imita movimentos de outras crianças ao brincar.', 1, 1),
(29, 'Imita um adulto em uma tarefa simples.', 2, 1),
(30, 'Brinca ao lado de outra criança, cada uma realizando tarefas diferentes.', 2, 1),
(31, 'Toma parte em uma brincadeira com outra criança por 2 a 5 minutos.', 2, 1),
(32, 'Aceita a ausência dos pais, embora possa reclamar.', 2, 1),
(33, 'Explora ativamente seu meio ambiente.', 2, 1),
(34, 'Realiza atividade manipulativa com outra pessoa.', 2, 1),
(35, 'Abraça e carrega uma boneca ou brinquedo macio.', 2, 1),
(36, 'Repete ações que produzem risos e atenção.', 2, 1),
(37, 'Dá um livro para que um adulto o leia ou para que ambos o compartilhem.', 2, 1),
(38, 'Puxa uma pessoa a mostrar-lhe algo.', 2, 1),
(39, 'Retira a mão ou diz "não" quando está próximo de um objeto não permitido e alguém o lembra disto.', 2, 1),
(40, 'Quando colocado em sua cadeira ou trocador espera ser atendido.', 2, 1),
(41, 'Brinca com 2 ou 3 crianças da sua idade.', 2, 1),
(42, 'Compartilha um objeto ou alimento com outra criança.', 2, 1),
(43, 'Cumprimenta colegas ou adultos quando lembrado.', 2, 1),
(44, 'Obedece às ordens dos pais pelo menos 1/2 das vezes.', 3, 1),
(45, 'Busca / leva um objeto ou pessoa, quando solicitado.', 3, 1),
(46, 'Presta atenção à estória ou música por 5 a 10 min.', 3, 1),
(47, 'Diz "Por favor" ou "Obrigado" quando lembrado.', 3, 1),
(48, 'Tenta ajudar os pais a executarem tarefas realizando parte da mesma.', 3, 1),
(49, 'Brinca de usar roupas de adultos.', 3, 1),
(50, 'Faz uma escolha quando indagado.', 3, 1),
(51, 'Demonstra entender sentimentos, expressando-os.', 3, 1),
(52, 'Canta e dança ao ouvir músicas.', 4, 1),
(53, 'Segue regras de um jogo imitando ações de outras crianças.', 4, 1),
(54, 'Cumprimenta pessoas familiares sem ser lembrado.', 4, 1),
(55, 'Seguem regras em jogos de grupos dirigidos por adultos.', 4, 1),
(56, 'Pede permissão para brincar com um brinquedo que está sendo usado por outra criança.', 4, 1),
(57, 'Diz "Por favor" e "Obrigado" sem ser lembrado 1/2 das vezes.', 4, 1),
(58, 'Atende ao telefone, chamando um adulto e falando com pessoas familiares.', 4, 1),
(59, 'Espera a sua vez.', 4, 1),
(60, 'Segue regras em jogos dirigidos por uma criança mais velha.', 4, 1),
(61, 'Obedece às ordens de um adulto 75% das vezes.', 4, 1),
(62, 'Permanece em seu próprio quintal ou jardim.', 4, 1),
(63, 'Brinca perto de outras crianças conversando com elas enquanto trabalha em um projeto próprio (30 min.).', 4, 1),
(64, 'Pede ajuda quando está tendo dificuldades.', 5, 1),
(65, 'Contribui para a conversa de adultos.', 5, 1),
(66, 'Repete rimas, canções ou dança para os outros.', 5, 1),
(67, 'Faz uma tarefa sozinha por 20 a 30 minutos.', 5, 1),
(68, 'Pede desculpas sem ser lembrado 75% das vezes.', 5, 1),
(69, 'Espera sua vez em brincadeiras que envolvam de 8 a 9 crianças.', 5, 1),
(70, 'Brinca com 2 a 3 crianças por 20 min. em uma atividade que envolva cooperação.', 5, 1),
(71, 'Quando em público, apresenta um comportamento socialmente aceitável.', 5, 1),
(72, 'Pede permissão para usar objetos dos outros em 75% das vezes.', 5, 1),
(73, 'Manifesta seus sentimentos.', 6, 1),
(74, 'Brinca com 4 a 5 crianças em atividade de cooperação por 20 minutos, sem supervisão.', 6, 1),
(75, 'Explica aos outros as regras do jogo ou atividade.', 6, 1),
(76, 'Imita papéis de adulto.', 6, 1),
(77, 'Colabora para a conversa durante as refeições.', 6, 1),
(78, 'Segue regras de jogo que envolva raciocínio verbal.', 6, 1),
(79, 'Conforta colegas quando estes estão tristes.', 6, 1),
(80, 'Escolhe seus próprios amigos.', 6, 1),
(81, 'Planeja e constrói, usando ferramentas simples.', 6, 1),
(82, 'Estabelece metas para si próprio e executa atividade para atingi-las.', 6, 1),
(83, 'Dramatiza trechos de histórias, desempenhando um papel ou utilizando fantoches.', 6, 1),
(1, 'Repete sons emitidos por outras pessoas.', 1, 2),
(2, 'Repete a mesma sílaba 2 a 3 vezes.', 1, 2),
(3, 'Responde a gestos com gestos.', 1, 2),
(4, 'Obedece a uma ordem simples, quando acompanhada de gestos indicativos.', 1, 2),
(5, 'Interrompe a atividade quando lhe dizem "Não" 75% das vezes.', 1, 2),
(6, 'Responde a perguntas simples com respostas não verbais.', 1, 2),
(7, 'Combina 2 sílabas diferentes quando tenta verbalizar.', 1, 2),
(8, 'Imita padrões de entonação da voz de outras pessoas.', 1, 2),
(9, 'Usa uma palavra funcionalmente para indicar objetos ou pessoas.', 1, 2),
(10, 'Vocaliza em resposta à fala de outras pessoas.', 1, 2),
(11, 'Diz 5 palavras diferentes.', 2, 2),
(12, 'Pede "mais".', 2, 2),
(13, 'Diz "acabou".', 2, 2),
(14, 'Obedece a 3 ordens diferentes que não são acompanhadas de gestos indicativos.', 2, 2),
(15, 'Consegue "dar" ou "mostrar" quando solicitado.', 2, 2),
(16, 'Aponta para 12 objetos quando nomeados.', 2, 2),
(17, 'Aponta para 3 a 5 figuras em um livro.', 2, 2),
(18, 'Aponta para 3 partes de seu próprio corpo.', 2, 2),
(19, 'Diz seu nome ou apelido quando solicitado.', 2, 2),
(20, 'Responde à pergunta "O que é isto?"', 2, 2),
(21, 'Combina palavras e gestos para expressar desejos.', 2, 2),
(22, 'Nomeia 5 membros da família, incluindo animais.', 2, 2),
(23, 'Nomeia 4 brinquedos.', 2, 2),
(24, 'Produz sons de animais, ou os nomeia pelo som.', 2, 2),
(25, 'Pede alimentos conhecidos pelo nome, quando mostrados.', 2, 2),
(26, 'Faz perguntas variando a entonação da voz.', 2, 2),
(27, 'Nomeia 3 partes do corpo em uma boneca ou outra pessoa.', 2, 2),
(28, 'Responde a perguntas de sim / não.', 2, 2),
(29, 'Combina substantivos ou adjetivos e substantivos em frases de 2 palavras.', 3, 2),
(30, 'Combina substantivo e verbo em frases de 2 palavras', 3, 2),
(31, 'Usa uma palavra para indicar que quer ir ao banheiro', 3, 2),
(32, 'Combina verbo ou substantivo com "lá" e "aqui" em frases de 2 palavras.', 3, 2),
(33, 'Combina 2 palavras para expressar posse.', 3, 2),
(34, 'Emprega "não" na fala.', 3, 2),
(35, 'Responde à pergunta "O que .... está fazendo?" para atividade habituais.', 3, 2),
(36, 'Responde a perguntas tipo "Onde está objeto?"', 3, 2),
(37, 'Nomeia sons ambientais familiares.', 3, 2),
(38, 'Dá mais de um objeto quando se usa a forma plural na solicitação.', 3, 2),
(39, 'Ao falar, refere-se a si próprio pelo nome.', 3, 2),
(40, 'Aponta para figuras de objetos comuns descritos pelo uso (até 10).', 3, 2),
(41, 'Mostra a idade pelos dedos.', 3, 2),
(42, 'Diz seu sexo quando solicitado.', 3, 2),
(43, 'Obedece à seqüência de duas ordens relacionadas.', 3, 2),
(44, 'Usa a forma do verbo no gerúndio.', 3, 2),
(45, 'Emprega formas regulares no plural.', 3, 2),
(46, 'Emprega algumas formas irregulares de verbos no passado de forma sistemática.', 3, 2),
(47, 'Faz perguntas do tipo "O que é isso?"', 3, 2),
(48, 'Controla o volume da voz 90% das vezes.', 3, 2),
(49, 'Usa "este / esta" e "aquele / aquela" na fala.', 3, 2),
(50, 'Emprega "é" e "está" em frases simples.', 3, 2),
(51, 'Diz "eu", "mim", "meu" ao invés do próprio nome.', 3, 2),
(52, 'Aponta objetos e diz que eles não são outras coisas.', 3, 2),
(53, 'Responde à pergunta "Quem?" dando um nome.', 3, 2),
(54, 'Emprega as formas possessivas dos substantivos.', 3, 2),
(55, 'Usa artigos ao falar.', 3, 2),
(56, 'Usa substantivos que indicam grupo ou categoria.', 3, 2),
(57, 'Usa os verbos "ser", "estar" e "ter" no presente com poucos erros.', 3, 2),
(58, 'Diz se os objetos estão abertos ou fechados.', 3, 2),
(59, 'Expressa diminutivos e aumentativos quando fala.', 4, 2),
(60, 'Presta atenção por 5 minutos a uma estória lida.', 4, 2),
(61, 'Obedece à sequência de 2 ordens não relacionadas.', 4, 2),
(62, 'Diz seu nome completo quando solicitado.', 4, 2),
(63, 'Responde perguntas simples envolvendo "Como".', 4, 2),
(64, 'Emprega verbos regulares, no passado.', 4, 2),
(65, 'Relata experiências imediatas.', 4, 2),
(66, 'Diz como são usados objetos comuns.', 4, 2),
(67, 'Expressa ações futuras empregando os verbos "ir", "ter" e "querer".', 4, 2),
(68, 'Utiliza adequadamente masculino e feminino na fala.', 4, 2),
(69, 'Usa formas imperativas de verbos ao pedir favores.', 4, 2),
(70, 'Conta 2 fatos na ordem de ocorrência.', 4, 2),
(71, 'Obedece a uma sequência envolvendo 3 ordens.', 5, 2),
(72, 'Demonstra compreensão de verbos reflexivos, usando-os ocasionalmente.', 5, 2),
(73, 'Consegue identificar objetos/figuras que formem par, sob solicitação.', 5, 2),
(74, 'Emprega o futuro ao falar.', 5, 2),
(75, 'Usa orações compostas por coordenação.', 5, 2),
(76, 'Consegue identificar a parte de cima e de baixo de objetos, quando solicitado.', 5, 2),
(77, 'Emprega ocasionalmente o condicional ao falar (poderia, pudesse, iria).', 5, 2),
(78, 'Consegue identificar absurdos em figuras.', 5, 2),
(79, 'Emprega as seguintes palavras: irmã(o), avó, avô.', 5, 2),
(80, 'Completa frases com antônimos.', 5, 2),
(81, 'Relata uma estória conhecida sem ajuda de figuras.', 5, 2),
(82, 'Em uma figura, nomeia o objeto que não pertence a uma categoria.', 5, 2),
(83, 'Diz se duas palavras rimam ou não.', 5, 2),
(84, 'Usa frases complexas, compostas por subordinação.', 5, 2),
(85, 'Diz se um som é forte ou fraco.', 5, 2),
(86, 'Consegue indicar alguns, muitos e vários elementos.', 6, 2),
(87, 'Diz seu endereço.', 6, 2),
(88, 'Diz o número de seu telefone.', 6, 2),
(89, 'Aponta para o conjunto que tem mais, menos ou poucos elementos.', 6, 2),
(90, 'Conta piadas simples.', 6, 2),
(91, 'Relata experiências diárias.', 6, 2),
(92, 'Descreve um local ou movimento: através ou entre, longe de, para, por cima.', 6, 2),
(93, 'Responde à pergunta "Porque" com uma explicação.', 6, 2),
(94, 'Ordena e conta uma estória de 2 a 5 episódios na sequência correta.', 6, 2),
(95, 'Define palavras.', 6, 2),
(96, 'Responde adequadamente a pergunta "Qual o contrário de ...".', 6, 2),
(97, 'Responde a pergunta "O que acontece se...".', 6, 2),
(98, 'Usa "ontem" e "amanhã", corretamente.', 6, 2),
(99, 'Pergunta o significado de palavras novas ou desconhecidas.', 6, 2),
(1, 'Remove um pano do rosto que obscureça sua visão.', 1, 3),
(2, 'Procura com o olhar um objeto que foi tirado de seu campo visual.', 1, 3),
(3, 'Remove um objeto de um recipiente colocando a mão dentro do mesmo.', 1, 3),
(4, 'Coloca um objeto em um recipiente imitando um adulto.', 1, 3),
(5, 'Coloca um objeto em um recipiente quando recebe instruções.', 1, 3),
(6, 'Balança um brinquedo que produz som, pendurado em um barbante.', 1, 3),
(7, 'Coloca três objetos em um recipiente e o esvazia.', 1, 3),
(8, 'Transfere um objeto de uma mão à outra para apanhar outro objeto.', 1, 3),
(9, 'Deixa cair e apanha um brinquedo.', 1, 3),
(10, 'Descobre um objeto escondido sob um recipiente.', 1, 3),
(11, 'Empurra 3 blocos como se fosse um comboio.', 1, 3),
(12, 'Remove um círculo de uma prancha, por imitação.', 1, 3),
(13, 'Coloca um pino redondo em uma prancha de pinos, quando solicitado.', 1, 3),
(14, 'Executa gestos simples quando requisitado.', 1, 3),
(15, 'Retira 6 objetos de um recipiente, um por vez.', 2, 3),
(16, 'Aponta para uma parte do corpo.', 2, 3),
(17, 'Empilha 3 blocos, dada a ordem.', 2, 3),
(18, 'Emparelha objetos semelhantes.', 2, 3),
(19, 'Faz rabiscos no papel.', 2, 3),
(20, 'Aponta para si quando perguntam "Cadê o Fulano?"', 2, 3),
(21, 'Coloca 5 pinos redondos, dada a ordem.', 2, 3),
(22, 'Emparelha objetos com a figura do mesmo nome.', 2, 3),
(23, 'Aponta para a figura nomeada.', 2, 3),
(24, 'Vira as páginas de um livro (2/3 por vez) para encontrar a figura nomeada.', 2, 3),
(25, 'Encontra determinado livro quando solicitado.', 3, 3),
(26, 'Completa um quebra-cabeça de encaixe de 3 peças.', 3, 3),
(27, 'Nomeia 4 objetos comuns em figuras.', 3, 3),
(28, 'Desenha uma linha vertical imitando um adulto.', 3, 3),
(29, 'Desenha uma linha horizontal imitando um adulto.', 3, 3),
(30, 'Copia um círculo.', 3, 3),
(31, 'Emparelha objetos com a mesma textura.', 3, 3),
(32, 'Aponta o "pequeno" e o "grande" quando solicitado.', 3, 3),
(33, 'Desenha (+) imitando um adulto.', 3, 3),
(34, 'Emparelha 3 cores.', 3, 3),
(35, 'Coloca objetos dentro, em cima e em baixo de um recipiente, dada a ordem.', 3, 3),
(36, 'Nomeia objetos quando ouve o barulho que fazem.', 3, 3),
(37, 'Monta um brinquedo de encaixe de 4 peças.', 3, 3),
(38, 'Nomeia ações em figuras ("O que ... está fazendo?").', 3, 3),
(39, 'Emparelha forma geométrica com a figura da mesma.', 3, 3),
(40, 'Empilha 5 ou mais argolas em uma vara na ordem.', 3, 3),
(41, 'Nomeia objetos como sendo grandes ou pequenos.', 4, 3),
(42, 'Aponta para 10 partes do corpo quando requisitado.', 4, 3),
(43, 'Aponta para menino e menina, dada a ordem.', 4, 3),
(44, 'Diz se um objeto é pesado ou leve.', 4, 3),
(45, 'Une 2 partes de uma figura para formar o todo.', 4, 3),
(46, 'Descreve 2 eventos ou personagens de uma estória familiar ou programa de TV.', 4, 3),
(47, 'Repete brincadeiras (rimas ou canções) que envolvam movimentos coordenados.', 4, 3),
(48, 'Emparelha 3 ou mais objetos.', 4, 3),
(49, 'Aponta para objetos compridos ou curtos.', 4, 3),
(50, 'Associa objetos correspondentes. Ex: meia/sapato.', 4, 3),
(51, 'Conta até 3 imitando um adulto.', 4, 3),
(52, 'Agrupa objetos em categorias.', 4, 3),
(53, 'Traça um (V) em imitação.', 4, 3),
(54, 'Traça uma linha diagonal dado o exemplo.', 4, 3),
(55, 'Conta até 10 objetos, imitando um adulto.', 4, 3),
(56, 'Constrói uma ponte com 3 blocos por imitação.', 4, 3),
(57, 'Emparelha uma sequência ou padrão (tamanho, cor) de blocos ou contas.', 4, 3),
(58, 'Copia uma série de (V) interligados.', 4, 3),
(59, 'Acrescenta perna ou braço em um desenho incompleto da figura humana.', 4, 3),
(60, 'Completa um quebra-cabeças de 6 peças.', 4, 3),
(61, 'Indica se os objetos são iguais ou diferentes.', 4, 3),
(62, 'Desenha um quadrado imitando um adulto.', 4, 3),
(63, 'Nomeia 3 cores sendo requisitado.', 4, 3),
(64, 'Nomeia 3 formas geométricas (quadrado, triângulo e círculo).', 4, 3),
(65, 'Apanha de 1 a 5 objetos quando solicitado.', 5, 3),
(66, 'Nomeia 5 texturas diferentes.', 5, 3),
(67, 'Copia um triângulo ao ser requisitado.', 5, 3),
(68, 'Recorda-se de 4 objetos que haviam sido vistos em uma figura.', 5, 3),
(69, 'Diz o momento do dia associado a cada atividade.', 5, 3),
(70, 'Repete rimas familiares.', 5, 3),
(71, 'Diz se um objeto é mais pesado ou mais leve.', 5, 3),
(72, 'Diz o que está faltando quando um objeto é retirado de um grupo de 3.', 5, 3),
(73, 'Nomeia 8 cores.', 5, 3),
(74, 'Identifica o valor de 3 moedas.', 5, 3),
(75, 'Emparelha símbolos (letras e números).', 5, 3),
(76, 'Diz a cor de objetos nomeados.', 5, 3),
(77, 'Relata 5 principais fatos de uma história contada 3x.', 5, 3),
(78, 'Desenha figura humana (cabeça, tronco e 4 membros).', 5, 3),
(79, 'Canta 5 estrofes de uma canção.', 5, 3),
(80, 'Constrói uma pirâmide de 10 blocos por imitação.', 5, 3),
(81, 'Nomeia objetos como sendo compridos ou curtos.', 5, 3),
(82, 'Coloca objetos "atrás", "ao lado" ou "junto" a outros.', 5, 3),
(83, 'Faz conjuntos iguais de 10 objetos, segundo modelo.', 5, 3),
(84, 'Nomeia ou aponta para a parte ausente da figura.', 5, 3),
(85, 'Conta de 1 a 20.', 5, 3),
(86, 'Identifica o objeto colocado no meio, em primeiro e em último lugar.', 5, 3),
(87, 'Conta até 20 objetos e responde: "Quantos ... você contou?".', 6, 3),
(88, 'Nomeia 10 numerais.', 6, 3),
(89, 'Identifica qual a sua esquerda e qual a sua direita.', 6, 3),
(90, 'Diz as vogais em ordem.', 6, 3),
(91, 'Escreve seu nome com letras de forma.', 6, 3),
(92, 'Nomeia 5 letras do alfabeto.', 6, 3),
(93, 'Ordena objetos em sequência de comprimento e largura.', 6, 3),
(94, 'Nomeia as letras maiúsculas do alfabeto.', 6, 3),
(95, 'Coloca numerais de 1 a 10 na sequência correta.', 6, 3),
(96, 'Identifica a posição de objetos em 1o, 2o e 3o lugar.', 6, 3),
(97, 'Nomeia as letras minúsculas do alfabeto.', 6, 3),
(98, 'Emparelha letras maiúsculas com minúsculas.', 6, 3),
(99, 'Aponta para numerais de 1 a 25.', 6, 3),
(100, 'Copia um losango.', 6, 3),
(101, 'Completa um labirinto simples.', 6, 3),
(102, 'Diz os dias da semana na ordem.', 6, 3),
(103, 'Soma e subtrai combinações de até 3 elementos.', 6, 3),
(104, 'Diz o mês e o dia de seu aniversário.', 6, 3),
(105, 'Lê 10 palavras impressas.', 6, 3),
(106, 'Prediz o que vai ocorrer.', 6, 3),
(107, 'Aponta para objetos inteiros e partidos ao meio.', 6, 3),
(108, 'Conta de memória de 1 a 100.', 6, 3),
(1, 'Suga e deglute líquidos.', 1, 4),
(2, 'Toma mingau / sopinha.', 1, 4),
(3, 'Estende as mãos em direção a mamadeira, tentando pegá-la.', 1, 4),
(4, 'Come alimentos liquidificados dados pelos pais.', 1, 4),
(5, 'Segura a mamadeira sem ajuda enquanto bebe.', 1, 4),
(6, 'Leva a mamadeira até a boca ou a recusa, empurrando-a.', 1, 4),
(7, 'Come alimentos amassados dados pelos pais.', 1, 4),
(8, 'Bebe em uma caneca, segurada pelos pais.', 1, 4),
(9, 'Come alimentos semissólidos dados pelos pais.', 1, 4),
(10, 'Alimenta-se sozinho usando os dedos.', 1, 4),
(11, 'Segura a caneca com ambas as mãos e bebe.', 1, 4),
(12, 'Leva a colher cheia de comida até a boca com ajuda.', 1, 4),
(13, 'Estica braços e pernas ao ser vestido.', 1, 4),
(14, 'Come com colher de modo independente.', 2, 4),
(15, 'Segura a caneca com uma só mão e bebe.', 2, 4),
(16, 'Coloca a mão na água e dá tapinhas no rosto imitando alguém.', 2, 4),
(17, 'Senta-se em um piniquinho ou sanitário infantil por 5 min.', 2, 4),
(18, 'Coloca um chapéu na cabeça e o remove.', 2, 4),
(19, 'Tira as meias.', 2, 4),
(20, 'Empurra os braços pelas mangas e os pés pelas pernas da calça.', 2, 4),
(21, 'Tira os sapatos quando os cordões estiverem desamarrados.', 2, 4),
(22, 'Tira o casaco quando desabotoado.', 2, 4),
(23, 'Tira a calça quando desabotoada.', 2, 4),
(24, 'Puxa um fecho grande para cima e para baixo.', 2, 4),
(25, 'Utiliza palavras ou gestos indicando necessidade de ir ao banheiro.', 2, 4),
(26, 'Alimenta-se sozinho derrubando pouco de comida ou líquido.', 3, 4),
(27, 'Enxuga as mãos e o rosto com ajuda.', 3, 4),
(28, 'Suga líquido do copo ou caneca usando canudinho.', 3, 4),
(29, 'Dá garfadas.', 3, 4),
(30, 'Mastiga e engole apenas substâncias comestíveis.', 3, 4),
(31, 'Enxuga as mãos sem ajuda ao lhe darem uma toalha.', 3, 4),
(32, 'Avisa que quer ir ao banheiro, mesmo sendo tarde demais.', 3, 4),
(33, 'Controla sua baba.', 3, 4),
(34, 'Urina ou defeca quando colocado no piniquinho (3x por semana).', 3, 4),
(35, 'Calça os sapatos.', 3, 4),
(36, 'Escova os dentes imitando um adulto.', 3, 4),
(37, 'Retira roupas simples que foram desabotoadas.', 3, 4),
(38, 'Usa o banheiro para defecar (falha apenas 1x por semana).', 3, 4),
(39, 'Obtém água de uma torneira sem ajuda.', 3, 4),
(40, 'Lava as mãos e o rosto com um sabonete.', 3, 4),
(41, 'Avisa que quer ir ao banheiro durante o dia a tempo.', 3, 4),
(42, 'Pendura o casaco em um gancho da sua altura.', 3, 4),
(43, 'Permanece seco ao dormir durante o dia.', 3, 4),
(44, 'Evita riscos, por ex: pontas em móveis e escadas sem corrimão.', 3, 4),
(45, 'Usa guardanapo quando recomendado.', 3, 4),
(46, 'Espeta o garfo na comida, levando-a a boca.', 3, 4),
(47, 'Despeja líquido de uma pequena jarra para o copo sem ajuda.', 3, 4),
(48, 'Desprende roupas presas com o feixe de pressão.', 3, 4),
(49, 'Lava seus braços e pernas ao lhe darem banho.', 3, 4),
(50, 'Coloca meias.', 3, 4),
(51, 'Veste casaco, malha ou camisa.', 3, 4),
(52, 'Identifica a parte dianteira da roupa.', 3, 4),
(53, 'Alimenta-se sozinho por toda a refeição.', 4, 4),
(54, 'Veste-se só, precisando de ajuda em golas fechadas ou botões.', 4, 4),
(55, 'Enxuga o nariz quando lembrado.', 4, 4),
(56, 'Acorda seco 2 manhãs por semana.', 4, 4),
(57, 'Se menino, urina no sanitário, em pé.', 4, 4),
(58, 'Veste-se e despe-se sozinho (exceto botões) 75% das vezes.', 4, 4),
(59, 'Fecha a roupa com fechos de pressão ou de gancho.', 4, 4),
(60, 'Assoa o nariz quando lembrado.', 4, 4),
(61, 'Evita perigos corriqueiros, por ex: caco de vidro.', 4, 4),
(62, 'Pendura roupa no cabide e põe no armário quando pedem.', 4, 4),
(63, 'Escova os dentes quando recebe instrução.', 4, 4),
(64, 'Coloca luvas.', 4, 4),
(65, 'Desabotoa botões grandes.', 4, 4),
(66, 'Abotoa botões grandes.', 4, 4),
(67, 'Calça botas.', 4, 4),
(68, 'Limpa o que derramou por conta própria.', 5, 4),
(69, 'Evita veneno e todas as substâncias prejudiciais.', 5, 4),
(70, 'Desabotoa sua roupa.', 5, 4),
(71, 'Abotoa sua roupa.', 5, 4),
(72, 'Retira prato e talheres da mesa.', 5, 4),
(73, 'Encaixa fecho em sua terminação.', 5, 4),
(74, 'Lava as mãos e o rosto.', 5, 4),
(75, 'Usa talher apropriado para alimentar-se.' , 5, 4),
(76, 'Acorda de noite para ir ao banheiro, ou acorda seco.', 5, 4),
(77, 'Limpa e assoa o nariz em 75% das vezes sem ser lembrado.', 5, 4),
(78, 'Toma banho só (precisa ajuda para costas, pescoço e orelhas).', 5, 4),
(79, 'Usa faca para espalhar manteiga no pão.', 5, 4),
(80, 'Aperta e afrouxa cintos ou fivelas.', 5, 4),
(81, 'Veste-se sozinho, mas não dá laços.', 5, 4),
(82, 'Serve-se à mesa enquanto seguram a travessa de comida.', 5, 4),
(83, 'Ajuda a pôr a mesa corretamente quando recebe instruções.', 5, 4),
(84, 'Escova os dentes.', 5, 4),
(85, 'Usa banheiro sozinho (tira roupa, papel, descarga e veste-se).', 5, 4),
(86, 'Penteia ou escova cabelos.', 5, 4),
(87, 'Pendura roupas em cabides.', 5, 4),
(88, 'Anda pela vizinhança sem constante supervisão.', 5, 4),
(89, 'Enfia cordões em sapatos.', 5, 4),
(90, 'Amarra ou dá laços nos cordões dos sapatos.', 5, 4),
(91, 'É responsável por uma tarefa semanal e a executa ao ser lembrado.', 6, 4),
(92, 'Seleciona roupas apropriadas ao clima e ocasião.', 6, 4),
(93, 'Olha para ambos os lados e atravessa a rua sem ser lembrado.', 6, 4),
(94, 'Serve-se à mesa e passa aos demais a panela de comida.', 6, 4),
(95, 'Prepara sua própria caneca de café com leite.', 6, 4),
(96, 'É responsável por uma tarefa diária em casa.', 6, 4),
(97, 'Ajusta a temperatura da água para o banho.', 6, 4),
(98, 'Prepara seu próprio lanche.', 6, 4),
(99, 'Anda sozinho até a distância de 2 quadras de casa.', 6, 4),
(100, 'Corta alimentos tenros com faca.', 6, 4),
(101, 'Encontra o banheiro em local público, corretamente.', 6, 4),
(102, 'Abre a embalagem de leite.', 6, 4),
(103, 'Apanha uma bandeja com comida, levando-a e pondo sobre a mesa.', 6, 4),
(104, 'Amarra os cordões em casacos com capuz.', 6, 4),
(105, 'Aperta o cinto de segurança do automóvel.', 6, 4),
(1, 'Alcança um objeto colocado à sua frente (15 a 20 cm.).', 1, 5),
(2, 'Apanha um objeto colocado à sua frente (8 cm.).', 1, 5),
(3, 'Estende os braços em direção a um objeto à sua frente e o apanha.', 1, 5),
(4, 'Alcança um objeto preferido.', 1, 5),
(5, 'Coloca objetos na boca.', 1, 5),
(6, 'Eleva a cabeça e o tronco apoiando-se nos braços (de bruços).', 1, 5),
(7, 'Levanta a cabeça e o tronco apoiando-se em um só braço.', 1, 5),
(8, 'Toca e explora objetos com a boca.', 1, 5),
(9, 'Em decúbito ventral (bruços), vira de lado e mantém a posição.', 1, 5),
(10, 'Em decúbito ventral, vira de costas.', 1, 5),
(11, 'Em decúbito ventral, move-se para frente o equivalente à sua altura.', 1, 5),
(12, 'Em decúbito dorsal (costas), rola para o lado.', 1, 5),
(13, 'Em decúbito dorsal, vira de barriga para baixo.', 1, 5),
(14, 'Faz esforço para sentar-se, segurando nos dedos do adulto.', 1, 5),
(15, 'Vira a cabeça com facilidade quando o corpo está apoiado.', 1, 5),
(16, 'Mantém-se sentado por 2 minutos.', 1, 5),
(17, 'Solta um objeto para apanhar outro.', 1, 5),
(18, 'Apanha e deixa cair um objeto propositalmente.', 1, 5),
(19, 'Fica em pé com o máximo de apoio.', 1, 5),
(20, 'Estando em pé com apoio, pula para cima e para baixo.', 1, 5),
(21, 'Engatinha para apanhar um objeto.', 1, 5),
(22, 'Senta-se apoiando-se sozinho.', 1, 5),
(23, 'Estando sentado, vira de gatinhas.', 1, 5),
(24, 'Estando em decúbito ventral consegue sentar-se.', 1, 5),
(25, 'Senta-se sem o apoio das mãos.', 1, 5),
(26, 'Atira objetos ao acaso.', 1, 5),
(27, 'Balança para frente e para trás quando de gatinhas.', 1, 5),
(28, 'Transfere objetos de uma mão para outra quando sentado.', 1, 5),
(29, 'Retém em uma das mãos 2 cubos de 2,5 cm.', 1, 5),
(30, 'Fica de joelhos.', 1, 5),
(31, 'Fica em pé, apoiando-se em algo.', 1, 5),
(32, 'Usa preensão de pinça para pegar objetos.', 1, 5),
(33, 'Engatinha.', 1, 5),
(34, 'Estando de gatinhas, estende uma das mãos para o alto.', 1, 5),
(35, 'Fica em pé com o mínimo de apoio.', 1, 5),
(36, 'Lambe a comida ao redor da boca.', 1, 5),
(37, 'Mantém-se em pé sozinho por um minuto.', 1, 5),
(38, 'Derruba um objeto que está dentro de um recipiente.', 1, 5),
(39, 'Vira várias páginas de um livro ao mesmo tempo.', 1, 5),
(40, 'Escava com uma colher ou pá.', 1, 5),
(41, 'Coloca pequenos objetos dentro do recipiente.', 1, 5),
(42, 'Estando de pé, abaixa-se e senta.', 1, 5),
(43, 'Bate palmas.', 1, 5),
(44, 'Anda com um mínimo de apoio.', 1, 5),
(45, 'Dá alguns passos sem apoio.', 1, 5),
(46, 'Sobe escadas engatinhando.', 2, 5),
(47, 'Coloca-se em pé, estando sentado.', 2, 5),
(48, 'Rola uma bola imitando um adulto.', 2, 5),
(49, 'Sobe em uma cadeira de adulto, vira-se e senta.', 2, 5),
(50, 'Coloca 4 aros em uma pequena estaca.', 2, 5),
(51, 'Retira pinos de 2,5 cm de uma prancha ou tabuleiro.', 2, 5),
(52, 'Encaixa pinos de 2,5 cm em uma prancha de encaixe.', 2, 5),
(53, 'Constrói uma torre de 3 blocos.', 2, 5),
(54, 'Faz traços no papel com lápis ou lápis de cera.', 2, 5),
(55, 'Anda sozinho.', 2, 5),
(56, 'Desce escadas sentado, colocando primeiro os pés.', 2, 5),
(57, 'Senta-se em uma cadeirinha.', 2, 5),
(58, 'Agacha-se e volta a ficar em pé.', 2, 5),
(59, 'Empurra e puxa brinquedos ao andar.', 2, 5),
(60, 'Usa cadeira ou cavalo de balanço.', 2, 5),
(61, 'Sobe escadas com ajuda.', 2, 5),
(62, 'Dobra o corpo sem cair para apanhar objetos no chão.', 2, 5),
(63, 'Imita um movimento circular.', 2, 5),
(64, 'Enfia 4 contas grandes em um cordão em 2 minutos.', 3, 5),
(65, 'Vira trincos ou maçanetas em portas.', 3, 5),
(66, 'Salta no mesmo local com ambos os pés.', 3, 5),
(67, 'Anda de costas.', 3, 5),
(68, 'Desce escadas sem ajuda.', 3, 5),
(69, 'Atira uma bola a um adulto à 1/2 distância.', 3, 5),
(70, 'Constrói uma torre de 5 a 6 blocos.', 3, 5),
(71, 'Vira páginas de um livro, uma por vez.', 3, 5),
(72, 'Desembrulha um pequeno objeto.', 3, 5),
(73, 'Dobra um papel ao meio, imitando um adulto.', 3, 5),
(74, 'Desmancha e reconstrói brinquedos de encaixe por pressão.', 3, 5),
(75, 'Desenrosca brinquedos que se encaixam por roscas.', 3, 5),
(76, 'Chuta uma bola grande que está imóvel.', 3, 5),
(77, 'Faz bolas de argila, barro ou massinha.', 3, 5),
(78, 'Segura o lápis entre o polegar e o indicador.', 3, 5),
(79, 'Dá cambalhota para frente com ajuda.', 3, 5),
(80, 'Dá marteladas para encaixar 5 pinos em seus orifícios.', 3, 5),
(81, 'Faz um quebra cabeça de 3 peças.', 4, 5),
(82, 'Corta algo em pedaços com tesoura.', 4, 5),
(83, 'Pula de uma altura de 20 cm.', 4, 5),
(84, 'Chuta uma bola grande quando enviada para si.', 4, 5),
(85, 'Anda na ponta dos pés.', 4, 5),
(86, 'Corre 10 passos coordenando movimentos de braços e pés.', 4, 5),
(87, 'Pedala com triciclo a distância de 1 metro e 12.', 4, 5),
(88, 'Balança em um balanço quando este está em movimento.', 4, 5),
(89, 'Sobe em um escorregador (1,20m a 1,80m) e escorrega.', 4, 5),
(90, 'Dá cambalhotas para frente.', 4, 5),
(91, 'Sobe escadas alternando os pés.', 4, 5),
(92, 'Marcha (anda de forma ritmada).', 4, 5),
(93, 'Apara a bola com ambas as mãos.', 4, 5),
(94, 'Desenha figuras seguindo contornos ou pontilhados.', 4, 5),
(95, 'Recorta ao longo de uma linha reta 20 cm.', 4, 5),
(96, 'Fica em um só pé sem apoio por 4 a 8 segundos.', 5, 5),
(97, 'Muda de direção ao correr.', 5, 5),
(98, 'Anda sobre uma viga ou tábua, mantendo o equilíbrio.', 5, 5),
(99, 'Pula para frente 10 vezes sem cair.', 5, 5),
(100, 'Salta sobre uma corda suspensa a 5 cm do solo.', 5, 5),
(101, 'Pula de costas 6 vezes.', 5, 5),
(102, 'Rebate e apanha uma bola grande.', 5, 5),
(103, 'Une 2 a 3 pedaços de massa de modelar.', 5, 5),
(104, 'Recorta em torno de linhas curvas.', 5, 5),
(105, 'Encaixa objetos de rosca.', 5, 5),
(106, 'Desce escadas alternando os pés.', 5, 5),
(107, 'Pedala um triciclo fazendo curvas.', 5, 5),
(108, 'Salta em um só pé 5 vezes consecutivas.', 5, 5),
(109, 'Recorta um círculo em 5 cm.', 5, 5),
(110, 'Desenha figuras simples facilmente identificáveis.', 5, 5),
(111, 'Recorta e cola formas simples.', 5, 5),
(112, 'Escreve letras de imprensa maiúsculas, isoladas e grandes.', 6, 5),
(113, 'Anda sobre uma tábua para trás, frente e lados.', 6, 5),
(114, 'Caminha saltitando.', 6, 5),
(115, 'Balança em um balanço iniciando e mantendo o movimento.', 6, 5),
(116, 'Estica os dedos tocando o polegar em cada um deles.', 6, 5),
(117, 'Copia letras maiúsculas.', 6, 5),
(118, 'Sobe em escadas de mão ou de escorregador de 3 m.', 6, 5),
(119, 'Bate em um prego com martelo.', 6, 5),
(120, 'Rebate a bola à medida que anda com direção.', 6, 5),
(121, 'Consegue colorir sem sair da margem em 95% das vezes.', 6, 5),
(122, 'Recorta figuras sem sair mais que 6 mm da margem.', 6, 5),
(123, 'Usa apontador de lápis.', 6, 5),
(124, 'Copia desenhos complexos (escola, navio).', 6, 5),
(125, 'Rasga figuras simples de um papel.', 6, 5),
(126, 'Dobra um papel quadrado 2x em diagonal por imitação.', 6, 5),
(127, 'Apanha uma bola leve com uma só mão.', 6, 5),
(128, 'Pula corda sozinho.', 6, 5),
(129, 'Golpeia uma bola com um bastão ou pedaço de pau.', 6, 5),
(130, 'Apanha um objeto no chão enquanto corre.', 6, 5),
(131, 'Patina uma distância de 3 m, ou usa skate.', 6, 5),
(132, 'Anda de bicicleta.', 6, 5),
(133, 'Escorrega descendo um monte de areia ou terra.', 6, 5),
(134, 'Anda ou brinca em piscina tendo água até a cintura.', 6, 5),
(135, 'Conduz um patinete dando impulso com um só pé.', 6, 5),
(136, 'Salta e gira em um só pé.', 6, 5),
(137, 'Escreve seu nome com letras de forma em caderno pautado.', 6, 5),
(138, 'Salta de uma altura de 30 cm. e cai na ponta dos pés.', 6, 5),
(139, 'Pára em um só pé sem apoio (olhos fechados, 10 segundos).', 6, 5),
(140, 'Dependura-se por 10 segundos em uma barra horizontal.', 6, 5);


INSERT INTO tb_atividade (id_paciente, id_atividade_personalizada, id_atividade_portage) VALUES
(1, 1, null),
(1, 2, null),
(1, 3, null),
(2, 4, null),
(2, 5, null),
(1, null, 1),
(1, null, 2),
(1, null, 3),
(2, null, 2),
(2, null, 4);


INSERT INTO tb_tipo_aplicacao (alternativa) VALUES
('Independente'),
('Auxílio parcial'),
('Auxílio total');


INSERT INTO tb_tentativa (resultado, observacao, data_tentativa, id_tipo_aplicacao, id_atividade) VALUES
(TRUE, 'Realizou a atividade com auxílio mínimo', curdate(), 1, 1),
(FALSE, 'Não conseguiu completar mesmo com apoio', curdate(), 2, 2),
(TRUE, 'Executou parcialmente a tarefa solicitada', curdate(), 3, 3),
(TRUE, 'Concluiu a atividade de forma independente', curdate(), 1, 4),
(FALSE, 'Demonstrou dificuldade de compreensão da tarefa', curdate(), 2, 5);

INSERT INTO tb_formulario (id_paciente, id_atividade_portage, id_resposta)
SELECT 1, id, NULL 
FROM tb_atividade_portage 
ORDER BY id ASC;

INSERT INTO tb_formulario (id_paciente, id_atividade_portage, id_resposta)
SELECT 2, id, NULL 
FROM tb_atividade_portage 
ORDER BY id ASC;

INSERT INTO tb_formulario (id_paciente, id_atividade_portage, id_resposta)
SELECT 3, id, NULL 
FROM tb_atividade_portage 
ORDER BY id ASC;

INSERT INTO tb_formulario (id_paciente, id_atividade_portage, id_resposta)
SELECT 4, id, NULL 
FROM tb_atividade_portage 
ORDER BY id ASC;

INSERT INTO tb_formulario (id_paciente, id_atividade_portage, id_resposta)
SELECT 5, id, NULL 
FROM tb_atividade_portage 
ORDER BY id ASC;

-- Dados do paciente (serie e grau de suporte ) pelo id
CREATE VIEW vw_data_paciente AS
SELECT
	paciente.id as id_paciente,
	paciente.nome as nome,
    paciente.foto as foto,
    paciente.data_nascimento as data_nascimento,
    paciente.cpf as cpf,
    serie_escolar.serie as serie,
    grau_suporte.grau as grau
FROM tb_paciente paciente
	JOIN tb_serie_escolar serie_escolar ON
    serie_escolar.id = paciente.id_serie_escolar
    JOIN tb_grau_suporte grau_suporte ON
    grau_suporte.id = paciente.id_grau_suporte
    ORDER BY paciente.id ASC;

-- Habilidades do paciente pelo id
CREATE VIEW vw_habilidades_paciente AS
SELECT
	paciente.id as id_paciente,
	habilidade.id as id_habilidade,
    habilidade.nome as nome_habilidade,
    relacao.idade_meses as idade_meses
FROM 
	tb_habilidade habilidade
	JOIN tb_paciente_habilidade relacao ON
    relacao.id_habilidade = habilidade.id
    JOIN tb_paciente paciente ON
    paciente.id = relacao.id_paciente
    ORDER BY paciente.id ASC;

-- Diagnóstico do paciente pelo id
CREATE VIEW vw_diagnostico_paciente AS
SELECT
	paciente.id as id_paciente,
	diagnostico.id as id_diagnostico,
    diagnostico.sigla as sigla,
    diagnostico.nome_completo_transtorno as nome_completo
FROM tb_sigla_transtorno diagnostico
	JOIN tb_paciente_transtorno transtorno ON
    transtorno.id_sigla_transtorno = diagnostico.id
    JOIN tb_paciente paciente ON
    transtorno.id_paciente = paciente.id
    ORDER BY paciente.id ASC; 

-- Psicopedagogo pelo id de paciente
CREATE VIEW vw_psicopedagogo_paciente AS
SELECT
	paciente.id AS id_paciente,
	usuario.id as id_usuario,
    usuario.nome as nome,
    usuario.telefone as telefone
FROM tb_usuario usuario
	JOIN tb_usuario_paciente relacao ON
    usuario.id = relacao.id_usuario
    JOIN tb_paciente paciente ON
    paciente.id = relacao.id_paciente
    WHERE usuario.id_tipo_usuario = 1
    ORDER BY paciente.id ASC;

-- Responsaveis pelo id de paciente
CREATE VIEW vw_responsavel_paciente AS
SELECT
	paciente.id AS id_paciente,
	usuario.id as id_usuario,
    usuario.nome as nome,
    usuario.telefone as telefone
FROM tb_usuario usuario
	JOIN tb_usuario_paciente relacao ON
    usuario.id = relacao.id_usuario
    JOIN tb_paciente paciente ON
    paciente.id = relacao.id_paciente
    WHERE usuario.id_tipo_usuario = 2
    ORDER BY paciente.id ASC;

CREATE VIEW vw_formulario_usuario AS
SELECT
	formulario.id_paciente as id_paciente,
	atividade.id as id_atividade,
    atividade.numero_questao as numero_questao,
    atividade.comportamento as comportamento,
    atividade.id_faixa_idade as id_faixa_idade,
    atividade.id_habilidade as id_habilidade,
	formulario.id_resposta as id_resposta
FROM tb_formulario formulario
	JOIN tb_atividade_portage atividade ON
    atividade.id = formulario.id_atividade_portage
    ORDER BY id_atividade_portage ASC;

CREATE VIEW vw_atividade_portage AS
SELECT
	'Portage' as tipo_atividade,
	tb_atividade.id as id_atividade,
    tb_atividade.concluida as concluida,
    tb_atividade_portage.numero_questao as numero_questao,
    tb_atividade_portage.comportamento as comportamento,
    tb_habilidade.id as id_habilidade,
    tb_habilidade.nome as nome_habilidade
    
    FROM tb_atividade
    JOIN tb_atividade_portage ON
    tb_atividade.id_atividade_portage = tb_atividade_portage.id
    JOIN tb_habilidade ON
    tb_habilidade.id = tb_atividade_portage.id_habilidade;
    
CREATE VIEW vw_atividade_personalizada AS
SELECT
	'Personalizada' as tipo_atividade,
	tb_atividade.id as id_atividade,
    tb_atividade.concluida as concluida,
    tb_atividade_personalizada.comportamento as comportamento,
    tb_atividade_personalizada.valor_meses as valor_meses,
    tb_habilidade.id as id_habilidade,
    tb_habilidade.nome as nome_habilidade
	
    FROM tb_atividade
    JOIN tb_atividade_personalizada ON
    tb_atividade_personalizada.id = tb_atividade.id_atividade_personalizada
	JOIN tb_habilidade ON
    tb_habilidade.id = tb_atividade_personalizada.id_habilidade;

CREATE VIEW vw_todas_atividades AS
SELECT
	tb_atividade.id_paciente as id_paciente,
	'Portage' as tipo_atividade,
	tb_atividade.id as id_atividade,
    tb_atividade.concluida as concluida,
    tb_atividade_portage.numero_questao as numero_questao,
    tb_atividade_portage.comportamento as comportamento,
    tb_habilidade.id as id_habilidade,
    tb_habilidade.nome as nome_habilidade,
    NULL as valor_meses
    
    FROM tb_atividade
    JOIN tb_atividade_portage ON
    tb_atividade.id_atividade_portage = tb_atividade_portage.id
    JOIN tb_habilidade ON
    tb_habilidade.id = tb_atividade_portage.id_habilidade
    
    UNION ALL

SELECT
	tb_atividade.id_paciente as id_paciente,
    'Personalizada' as tipo_atividade,
	tb_atividade.id as id_atividade,
    tb_atividade.concluida as concluida,
    NULL AS numero_questao,
    tb_atividade_personalizada.comportamento as comportamento,
    tb_habilidade.id as id_habilidade,
    tb_habilidade.nome as nome_habilidade,
    tb_atividade_personalizada.valor_meses as valor_meses
	
    FROM tb_atividade
    JOIN tb_atividade_personalizada ON
    tb_atividade_personalizada.id = tb_atividade.id_atividade_personalizada
	JOIN tb_habilidade ON
    tb_habilidade.id = tb_atividade_personalizada.id_habilidade
    ORDER BY numero_questao;

CREATE VIEW vw_atividade_portage_nao_desenvolvida AS
SELECT 
	tb_formulario.id_paciente AS id_paciente,
	tb_atividade_portage.id AS id_atividade_portage,
    tb_atividade_portage.numero_questao AS numero_questao,
    tb_atividade_portage.comportamento AS comportamento,
    tb_habilidade.id AS id_habilidade,
    tb_habilidade.nome AS nome_habilidade,
    tb_atividade_portage.id_faixa_idade AS id_faixa_idade
    FROM tb_atividade_portage
    JOIN tb_habilidade ON
    tb_atividade_portage.id_habilidade = tb_habilidade.id
    JOIN tb_formulario ON
    tb_formulario.id_atividade_portage = tb_atividade_portage.id
    WHERE tb_formulario.id_resposta IS NOT TRUE;

CREATE VIEW vw_tentativas AS
SELECT
	
	tb_tentativa.id as id_tentativa,
    tb_tentativa.resultado as resultado,
    tb_tentativa.data_tentativa as data_tentativa,
    tb_tentativa.observacao as observacao,
    tb_tipo_aplicacao.alternativa as auxilio,
    tb_atividade.id AS id_atividade,
    NULL AS numero_questao,
    tb_atividade_personalizada.comportamento AS comportamento,
    tb_habilidade.id as id_habilidade,
    tb_habilidade.nome as nome_habilidade
	
    FROM tb_tentativa
    JOIN tb_tipo_aplicacao ON
    tb_tipo_aplicacao.id = tb_tentativa.id_tipo_aplicacao
    JOIN tb_atividade ON
    tb_atividade.id = tb_tentativa.id_atividade
    JOIN tb_atividade_personalizada ON
    tb_atividade_personalizada.id = tb_atividade.id_atividade_personalizada
    JOIN tb_habilidade ON
    tb_habilidade.id = tb_atividade_personalizada.id_habilidade

UNION ALL

SELECT 
	tb_tentativa.id as id_tentativa,
    tb_tentativa.resultado as resultado,
    tb_tentativa.data_tentativa as data_tentativa,
    tb_tentativa.observacao as observacao,
    tb_tipo_aplicacao.alternativa as auxilio,
    tb_atividade.id AS id_atividade,
    tb_atividade_portage.numero_questao AS numero_questao,
    tb_atividade_portage.comportamento AS comportamento,
    tb_habilidade.id as id_habilidade,
    tb_habilidade.nome as nome_habilidade
	
    FROM tb_tentativa
    JOIN tb_tipo_aplicacao ON
    tb_tipo_aplicacao.id = tb_tentativa.id_tipo_aplicacao
    JOIN tb_atividade ON
    tb_atividade.id = tb_tentativa.id_atividade
    JOIN tb_atividade_portage ON
    tb_atividade_portage.id = tb_atividade.id_atividade_portage
    JOIN tb_habilidade ON
    tb_habilidade.id = tb_atividade_portage.id_habilidade
    ORDER BY data_tentativa DESC;

    DELIMITER $$

CREATE PROCEDURE prc_usuario(
	IN p_id INT,
    OUT p_message JSON
) BEGIN
	
    DECLARE v_foto VARCHAR(255);
    DECLARE v_nome VARCHAR(150);
    DECLARE v_data_nascimento DATE;
    DECLARE v_telefone VARCHAR(20);
    DECLARE v_email VARCHAR(255);
    
    DECLARE data_hoje DATE;
    SET data_hoje = curdate();
		
    IF NOT EXISTS (
		
        SELECT 1
        FROM tb_usuario
        WHERE id = p_id
        
    ) THEN 
		SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Não foram encontrados dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    ELSE
		
        SELECT foto, nome, data_nascimento, telefone, email
        INTO v_foto, v_nome, v_data_nascimento, v_telefone, v_email
        FROM tb_usuario
        WHERE id = p_id;
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', JSON_OBJECT(
				'id', p_id,
                'foto', v_foto,
                'nome', v_nome,
                'email', v_email,
                'data_nascimento', v_data_nascimento,
                'telefone', v_telefone
            )
        );
    
    END IF;
    
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_usuario_login(
    IN p_email VARCHAR(255),
    IN p_senha VARCHAR(255),
    OUT v_id INT,
    OUT p_message JSON
) BEGIN

	DECLARE data_hoje DATE;

	SET data_hoje = CURDATE();

	SELECT id INTO v_id
	FROM tb_usuario 
	WHERE email = p_email AND senha = p_senha;

    IF v_id IS NULL THEN

        SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Não foram encontrados dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSE 
    
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Requisição feita com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_home(v_id, @resultHome);
        
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_home(
	IN p_id_usuario INT,
    OUT p_message JSON
) BEGIN 
	
    DECLARE v_id INT;
    DECLARE v_foto VARCHAR(150);
    DECLARE v_nome VARCHAR(255);
	DECLARE v_tipo_usuario VARCHAR(40);
    DECLARE data_hoje DATE;
    DECLARE return_object JSON;
    
    SET data_hoje = curdate();
    
    IF NOT EXISTS (
		SELECT 1
		FROM tb_usuario
        WHERE id = p_id_usuario 
    
    ) THEN SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Não foram encontrados dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
	
    ELSE
    
		SELECT usuario.nome, usuario.foto, tipo_usuario.tipo_usuario
        INTO v_nome, v_foto, v_tipo_usuario
        FROM tb_usuario usuario
        INNER JOIN tb_tipo_usuario tipo_usuario
        ON tipo_usuario.id = usuario.id_tipo_usuario
        WHERE usuario.id = p_id_usuario;
        
        SELECT JSON_ARRAYAGG(
			JSON_OBJECT(
				'id', paciente.id,
                'foto', paciente.foto,
                'nome', paciente.nome,
                'data_nascimento', DATE_FORMAT(paciente.data_nascimento, '%d/%m/%Y'),
                'idade', TIMESTAMPDIFF(YEAR, paciente.data_nascimento, CURDATE()),
                'cpf', paciente.cpf,
                'serie_escolar', serie.serie,
                'grau_suporte', grau_suporte.grau,
                'diagnostico_breve', (
					SELECT IFNULL(JSON_ARRAYAGG(
						JSON_OBJECT(
							'id_transtorno', diagnostico.id,
							'sigla', diagnostico.sigla,
                            'nome_completo', diagnostico.nome_completo_transtorno
                        )
                    ), JSON_ARRAY())
                    FROM tb_paciente_transtorno transtorno
                    JOIN tb_sigla_transtorno diagnostico
                    ON transtorno.id_sigla_transtorno = diagnostico.id
                    WHERE transtorno.id_paciente = paciente.id
                )
            )
        )
        
        INTO return_object
        FROM tb_paciente paciente
        JOIN tb_usuario_paciente relacao
        ON relacao.id_paciente = paciente.id
        JOIN tb_serie_escolar serie
        ON serie.id = paciente.id_serie_escolar
        JOIN tb_grau_suporte grau_suporte
        ON grau_suporte.id = paciente.id_grau_suporte
        WHERE relacao.id_usuario = p_id_usuario
        ORDER BY paciente.id ASC;
        
        IF v_tipo_usuario = 'Psicopedagogo' THEN 
        
			SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', JSON_OBJECT(
                'id', p_id_usuario,
                'foto', v_foto,
                'nome', v_nome,
                'tipo_usuario', v_tipo_usuario,
                'pacientes', return_object                
            )
        );
        
        ELSE 
         
         SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', JSON_OBJECT(
                'id', p_id_usuario,
                'foto', v_foto,
                'nome', v_nome,
                'tipo_usuario', v_tipo_usuario,
                'familiares', return_object
            )
        );
        
        END IF;
        
    END IF; 

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_cria_usuario(
	IN p_nome VARCHAR(150),
    IN p_email VARCHAR(255),
    IN p_senha VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_telefone VARCHAR(20),
    IN p_id_tipo_usuario INT,
    OUT p_message JSON
) BEGIN
	
	DECLARE data_hoje DATE;

	SET data_hoje = CURDATE();
    
    IF EXISTS(
    
		SELECT 1 
        FROM tb_usuario 
        WHERE email = p_email
        
    ) THEN SET p_message = JSON_OBJECT(
			'status', FALSE,
            'status_code', 409,
            'message', 'Existem dados de inserção já cadastrados no sistema!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
        
    ELSE
    
		INSERT INTO tb_usuario (
				nome,
				data_nascimento,
				telefone,
				email,
				senha,
				id_tipo_usuario
		) VALUES (
				p_nome,
				p_data_nascimento,
				p_telefone,
				p_email,
				p_senha,
				p_id_tipo_usuario
		);
		
		SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 201,
            'message', 'Cadastro bem sucedido!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
        
		CALL prc_usuario_login(p_email, p_senha, @idUsuarioLogin, @resultUsuarioLogin);
    
    END IF;
    
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualiza_usuario(
	IN p_id INT,
	IN p_foto VARCHAR(255),
	IN p_nome VARCHAR(150),
    IN p_email VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_telefone VARCHAR(20),
    OUT p_message JSON
) BEGIN 
	
    DECLARE data_hoje DATE;
    SET data_hoje = curdate();
    
    IF NOT EXISTS (
		SELECT 1
        FROM tb_usuario
        WHERE id = p_id
    ) THEN SET p_message = JSON_OBJECT(
		'status', FALSE,
		'status_code', 404,
		'message', 'Não foram encontrados dados de retorno!!!',
		'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
    );
	
    ELSEIF EXISTS (
		SELECT 1 
        FROM tb_usuario
        WHERE email = p_email AND id != p_id
    ) THEN SET p_message = JSON_OBJECT(
		'status', FALSE,
		'status_code', 409,
		'message', 'Existem dados de inserção já cadastrados no sistema!!!',
		'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
	);
	
	ELSE
	
		UPDATE tb_usuario SET
			foto = p_foto,
            nome = p_nome,
            email = p_email,
            data_nascimento = p_data_nascimento,
            telefone = p_telefone
		WHERE id = p_id;
            
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_usuario(p_id, @resultUsuario);
    
    END IF;
    
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_solicita_redefinicao_senha(
	
    IN p_email VARCHAR(255),
    OUT p_message JSON

) BEGIN 

	DECLARE data_hoje DATE;
    SET data_hoje = curdate();

	IF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE email = p_email) THEN
    
		SET p_message = JSON_OBJECT(
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    ELSE
    
		SET p_message = JSON_OBJECT(
			'status', TRUE,
			'status_code', 200,
			'message', 'Requisição bem sucedida!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    END IF;
    
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualiza_senha_usuario(

	IN p_id INT,
	IN p_senha VARCHAR(255),
    OUT p_message JSON

) BEGIN
	
    DECLARE data_hoje DATE;
    SET data_hoje = curdate();
    
	IF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id) THEN
		
		SET p_message =JSON_OBJECT(
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
			
    ELSE
    
		UPDATE tb_usuario SET
			senha = p_senha
		WHERE id = p_id;
    
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_home(p_id, @resultHome);
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_deleta_usuario(
	
    IN p_id INT,
    IN p_senha VARCHAR(255),
	OUT p_message JSON 
    
) BEGIN
	
    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();
    
    IF NOT EXISTS (
		SELECT 1
        FROM tb_usuario
        WHERE id = p_id
    ) THEN SET p_message = JSON_OBJECT(
		'status', FALSE,
		'status_code', 404,
		'message', 'Não foram encontrados dados de retorno!!!',
		'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
    );
    
    ELSEIF (
		SELECT 1
        FROM tb_usuario
        WHERE id = p_id AND senha = p_senha
    ) THEN 
		
        DELETE FROM tb_usuario WHERE id = p_id AND senha = p_senha;
    
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Item deletado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    ELSE 
		
        SET p_message = JSON_OBJECT(
		'status', FALSE,
		'status_code', 401,
		'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
		'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
    );
    
    
    END IF;

END$$
    
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_buscar_paciente_completo(
    IN p_id_paciente INT,
    OUT p_mensagem JSON
) BEGIN

    -- PACIENTE
    DECLARE v_nome VARCHAR(150);
    DECLARE v_foto VARCHAR(255);
    DECLARE v_data_nascimento DATE;
    DECLARE v_cpf VARCHAR(20);
    DECLARE v_serie_escolar VARCHAR(30);
    DECLARE v_grau_suporte VARCHAR(30);

    -- JSONS
    DECLARE v_diagnostico 	JSON;
    DECLARE v_habilidades 	JSON;
    DECLARE v_psicopedagogo JSON;
    DECLARE v_responsaveis 	JSON;
    
    DECLARE data_hoje DATE;
    SET data_hoje = curdate();

    -- VALIDAÇÃO
    IF NOT EXISTS (
        SELECT 1 FROM tb_paciente WHERE id = p_id_paciente
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSE

        -- PACIENTE
        SELECT nome, foto, data_nascimento, cpf, serie, grau
        INTO v_nome, v_foto, v_data_nascimento, v_cpf, v_serie_escolar, v_grau_suporte
        FROM vw_data_paciente WHERE id_paciente = p_id_paciente;

		-- DIAGNÓSTICO
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'sigla', 			diagnostico.sigla,
                'id_transtorno', 	diagnostico.id_diagnostico,
                'nome_completo', 	diagnostico.nome_completo
            )
        )
        INTO v_diagnostico
        FROM vw_diagnostico_paciente diagnostico
        WHERE id_paciente = p_id_paciente;
        
        SET v_diagnostico = IFNULL(v_diagnostico, JSON_ARRAY());

        -- HABILIDADES
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', 			habilidade_paciente.id_habilidade,
                'nome', 		habilidade_paciente.nome_habilidade,
                'idade_meses', 	habilidade_paciente.idade_meses
            )
        )
        INTO v_habilidades 
        FROM vw_habilidades_paciente habilidade_paciente
        WHERE id_paciente = p_id_paciente;

        SET v_habilidades = IFNULL(v_habilidades, JSON_ARRAY());

        -- RESPONSÁVEIS
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', 		responsavel.id_usuario,
                'nome', 	responsavel.nome,
                'telefone', responsavel.telefone
            )
        )
        INTO v_responsaveis
        FROM vw_responsavel_paciente responsavel
        WHERE id_paciente = p_id_paciente;

        SET v_responsaveis = IFNULL(v_responsaveis, JSON_ARRAY());

		-- PSICOPEDAGOGO
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', 		psicopedagogo.id_usuario,
                'nome', 	psicopedagogo.nome,
                'telefone', psicopedagogo.telefone
            )
        )
        INTO v_psicopedagogo
        FROM vw_psicopedagogo_paciente psicopedagogo
        WHERE id_paciente = p_id_paciente;

        SET v_psicopedagogo = IFNULL(v_psicopedagogo, JSON_ARRAY());

        -- RETORNO FINAL
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', '200',
            'message', 'Paciente encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', JSON_OBJECT(
                'id', p_id_paciente,
                'foto', v_foto,
                'nome', v_nome,
                'data_nascimento', DATE_FORMAT(v_data_nascimento, '%d/%m/%Y'),
                'idade', TIMESTAMPDIFF(YEAR, v_data_nascimento, CURDATE()),
                'cpf', v_cpf,
                'grau_suporte', v_grau_suporte,
                'serie_escolar', v_serie_escolar,
                'grafico', v_habilidades,
                'diagnostico', v_diagnostico,
				'psicopedagogo', v_psicopedagogo,
                'responsavel', v_responsaveis
            )
        );

    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_adicionar_paciente(
    IN p_foto VARCHAR(255),
	IN p_nome VARCHAR(150),
    IN p_diagnostico VARCHAR(400),
    IN p_cpf VARCHAR(20),
    IN p_data_nascimento DATE,
    IN p_id_serie_escolar INT,
    IN p_id_grau_suporte INT,
    IN p_id_responsavel INT,
    OUT p_mensagem JSON
) BEGIN

	DECLARE novo_id INT;
	DECLARE data_hoje DATE;
    SET data_hoje = curdate();


    -- valida duplicidade
    IF EXISTS (
        SELECT 1 FROM tb_paciente WHERE cpf = p_cpf
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Dados de inserção foram encontrados já cadastrados!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_serie_escolar WHERE id = p_id_serie_escolar) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'Não foi possível processar a requisição pois existem campos obrigatórios que devem ser encaminhados, e atendidos conforme documentação!!! [ID SÉRIE ESCOLAR]',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_grau_suporte WHERE id = p_id_grau_suporte) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'Não foi possível processar a requisição pois existem campos obrigatórios que devem ser encaminhados, e atendidos conforme documentação!!! [ID GRAU DE SUPORTE]',
            'data', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id_responsavel) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'Não foi possível processar a requisição pois existem campos obrigatórios que devem ser encaminhados, e atendidos conforme documentação!!! [ID RESPONSAVEL]',
            'data', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_responsavel AND id_tipo_usuario = 2) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 401,
            'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
            'data', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    ELSE

        -- insert paciente
        INSERT INTO tb_paciente(
            foto,
            nome,
            cpf,
            data_nascimento,
            id_serie_escolar,
            id_grau_suporte,
            id_usuario
        )
        VALUES (
            p_foto,
            p_nome,
            p_cpf,
            p_data_nascimento,
            p_id_serie_escolar,
            p_id_grau_suporte,
            p_id_responsavel
        );

        SET novo_id = LAST_INSERT_ID();

        -- vínculo responsável
        INSERT INTO tb_usuario_paciente(id_usuario, id_paciente)
        VALUES (p_id_responsavel, novo_id);

        INSERT INTO tb_paciente_transtorno (id_paciente, id_sigla_transtorno)
        SELECT novo_id, v_id_transtorno
        FROM JSON_TABLE(
			p_diagnostico,
            '$[*]' COLUMNS (
				v_id_transtorno INT PATH '$'
            )
        ) AS lista_transtornos;

		
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Item criado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_buscar_paciente_completo(novo_id, @resultPaciente);

    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualizar_paciente(

	IN p_id_usuario INT,
	IN p_id_paciente INT,
	IN p_nome VARCHAR(150),
    IN p_foto VARCHAR(255),
    IN p_data_nascimento DATE,
    IN p_diagnostico VARCHAR(400),
    IN p_cpf VARCHAR(20),
    IN p_id_serie_escolar INT,
    IN p_id_grau_suporte INT,
    OUT p_mensagem JSON
    
) BEGIN
    
	DECLARE data_hoje DATE;
    SET data_hoje = curdate();
    
    IF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id_usuario) THEN 
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Não foram encontrados, dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
        
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 2) THEN
    
		SET p_mensagem = JSON_OBJECT(
			'status', TRUE,
			'status_code', 401,
			'message', 'Não autorizado',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
		
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario_paciente WHERE id_paciente = p_id_paciente AND id_usuario = p_id_usuario) THEN
    
		SET p_mensagem = JSON_OBJECT(
			'status', TRUE,
			'status_code', 401,
			'message', 'Não autorizado',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Não foram encontrados, dados de retorno!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    ELSEIF EXISTS (SELECT 1 FROM tb_paciente WHERE cpf = p_cpf AND id != p_id_paciente) THEN
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Dados de inserção foram encontrados já cadastrados!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_serie_escolar WHERE id = p_id_serie_escolar) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_serie_esolar Incorreto',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_grau_suporte WHERE id = p_id_grau_suporte) THEN
		
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 400,
            'message', 'id_grau_suporte Incorreto',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
    ELSE
		
        -- atualiza o paciente
        UPDATE tb_paciente SET
			nome = p_nome,
            foto = p_foto,
            cpf = p_cpf,
            data_nascimento = p_data_nascimento,
            id_serie_escolar = p_id_serie_escolar,
            id_grau_suporte = p_id_grau_suporte
		WHERE id = p_id_paciente;
    
		INSERT INTO tb_paciente_transtorno (id_paciente, id_sigla_transtorno)
        SELECT p_id_paciente, v_id_transtorno
        FROM JSON_TABLE(
			p_diagnostico,
            '$[*]' COLUMNS (
				v_id_transtorno INT PATH '$'
            )
        ) AS lista_transtornos;
    
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
			'status_code', 200,
            'message', 'Item atualizado com sucesso'
        );
        
        CALL prc_buscar_paciente_completo(p_id_paciente, @resultPaciente);
        
	END IF;
    
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE proc_delete_paciente(
	IN p_id_usuario INT,
	IN p_id_paciente INT,
    OUT p_mensagem JSON
) BEGIN
	
	DECLARE data_hoje DATE;
    SET data_hoje = curdate();
    
    -- valida se o paciente existe
    IF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
	
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
	
    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = p_id_paciente) THEN
    
		SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
			'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    ELSE
		
        IF  EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 2) THEN
        
			DELETE FROM tb_usuario_paciente 	WHERE id_paciente = p_id_paciente;
			DELETE FROM tb_paciente_habilidade	WHERE id_paciente = p_id_paciente;
			DELETE FROM tb_paciente_transtorno 	WHERE id_paciente = p_id_paciente;
			DELETE FROM tb_formulario			WHERE id_paciente = p_id_paciente;
			DELETE FROM tb_atividade			WHERE id_paciente = p_id_paciente;
            DELETE FROM tb_paciente				WHERE id = p_id_paciente;
        
			SET p_mensagem = JSON_OBJECT(
				'status', TRUE,
				'status_code', 200,
				'message', 'Delete realizado com sucesso',
				'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
            );
        
        ELSEIF EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN
			
			DELETE FROM tb_usuario_paciente WHERE id_paciente = p_id_paciente AND id_usuario = p_id_usuario;
        
			SET p_mensagem = JSON_OBJECT(
				'status', TRUE,
				'status_code', 200,
				'message', 'Delete realizado com sucesso',
				'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
            );
        
        ELSE
        
			SET p_mensagem = JSON_OBJECT(
				'status', TRUE,
				'status_code', 401,
				'message', 'Não autorizado',
				'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
            );
        
		END IF;
    
    END IF;
    
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_inserir_relacao_usuario_paciente(
    IN p_id_paciente INT,
    IN p_id_usuario INT,
    OUT p_mensagem JSON
) BEGIN

	DECLARE data_hoje DATE;
    SET data_hoje = curdate();

    -- valida paciente
    IF NOT EXISTS (
        SELECT 1 FROM tb_paciente WHERE id = p_id_paciente
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    -- valida psicopedagogo
    ELSEIF NOT EXISTS (
        SELECT 1 FROM tb_usuario WHERE id = p_id_usuario
    ) THEN

        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Usuário não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
	ELSEIF EXISTS (
        SELECT 1 
        FROM tb_usuario_paciente 
        WHERE id_paciente = p_id_paciente 
          AND id_usuario = p_id_usuario
    ) THEN
    
        SET p_mensagem = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Essa relação já existe',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSE

        INSERT INTO tb_usuario_paciente (id_usuario, id_paciente) VALUES (p_id_usuario, p_id_paciente);

        -- sobrescreve mensagem
        SET p_mensagem = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Item criado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_buscar_paciente_completo(p_id_paciente, @resultPaciente);

    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_retorna_paciente_pelo_cpf(

	IN p_cpf VARCHAR(20),
    OUT p_message JSON

) BEGIN
	
	DECLARE data_hoje DATE;
    SET data_hoje = curdate();

	IF NOT EXISTS(
		SELECT 1
        FROM tb_paciente
        WHERE cpf = p_cpf
    ) THEN  SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 404,
            'message', 'Paciente não encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    ELSE
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

        CALL prc_buscar_paciente_completo((
            SELECT id FROM tb_paciente WHERE cpf = p_cpf
        ), @resultPaciente);
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE prc_atualizar_respostas_formulario(
	IN p_id_usuario INT,
    IN p_id_paciente INT,
    IN p_lista_respostas JSON,
    OUT p_message JSON
) BEGIN 

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS(SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = p_id_paciente) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
    
    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
    
	ELSE
    
		-- INICIA UPDATE NA TABELA FORMULARIO
		UPDATE tb_formulario
		JOIN JSON_TABLE( -- JOIN CRIA A TABELA VIRTUAL, E JSON_TABLE É RESPONSÁVEL POR LER OS JSONS
			p_lista_respostas, -- ARRAY JSON VINDO DO BACK
			'$[*]' COLUMNS ( -- [*] QUER DIZER: PERCORRA TODOS OS OBJETOS DENTRO DO ARRAY JSON
				id_atividade_portage INT PATH '$.id_atividade_portage', -- CRIA COLUNA VIRTUAL, O PATH INDICA ONDE PROCURAR NO JSON
				id_resposta INT PATH '$.id_resposta'
			)
		) AS novo_formulario 
		
		ON tb_formulario.id_atividade_portage = novo_formulario.id_atividade_portage -- ENCONTRE A LINHA DE TB_FORMULARIO ONDE O ID DA ATIVIDADE PORTAGE SEJA IGUAL A QUE VEM DO JSON
		SET tb_formulario.id_resposta = novo_formulario.id_resposta -- PEGUE O VALOR DE RESPOSTA QUE ESTÁ NO BANCO E SUBSTITUA PELO VALOR DE RESPOSTA VINDO DO JSON
		WHERE tb_formulario.id_paciente = p_id_paciente;
		
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        CALL prc_buscar_paciente_completo(p_id_paciente, @resultPaciente);
        
    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_formulario_pelo_id_paciente(
	IN p_id_usuario INT,
    IN p_id_paciente INT,
    OUT p_message JSON
	
) BEGIN

	DECLARE array_comportamento JSON;
	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();
    
    
    IF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
        
	ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
        
	ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario_paciente WHERE id_paciente = p_id_paciente AND id_usuario = p_id_usuario) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
        
	ELSE
		
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
				'id_atividade_portage', id_atividade,
                'numero_questao', numero_questao,
                'comportamento', comportamento,
                'id_faixa_idade', id_faixa_idade,
                'id_habilidade', id_habilidade,
                'id_resposta', id_resposta
            )
        ) FROM vw_formulario_usuario WHERE id_paciente = p_id_paciente
        INTO array_comportamento;
        
		SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', '200',
            'message', 'Formulario encontrado',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', array_comportamento
        );
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_inserir_atividade_tipo_portage(
    IN p_id_usuario INT,
    IN p_id_paciente INT,
    IN p_id_atividade_portage INT,
    OUT p_message JSON
) BEGIN

    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

    IF NOT EXISTS (SELECT 1 FROM tb_usuario where id = p_id_usuario) THEN
    
        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = p_id_paciente) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
        
	ELSEIF EXISTS (SELECT 1 FROM tb_atividade WHERE id_atividade_portage = p_id_atividade_portage) THEN 

		SET p_message = JSON_OBJECT(
            'status', FALSE,
            'status_code', 409,
            'message', 'Essa relação já existe',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_atividade_portage WHERE id = p_id_atividade_portage) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSE

        INSERT INTO tb_atividade (

            id_paciente,
            id_atividade_portage

        ) VALUES (

            p_id_paciente,
            p_id_atividade_portage

        );

        SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 201,
            'message', 'Inserção feita com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
        
        call prc_atividades(p_id_paciente, 
		( SELECT id_habilidade FROM tb_atividade_portage WHERE id = p_id_atividade_portage )
        , @resultAtividade);


    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_inserir_atividade_tipo_personalizada(
    IN p_id_usuario INT,
    IN p_id_paciente INT,
    IN p_comportamento VARCHAR(300),
    IN p_valor_meses INT,
    IN p_id_habilidade INT,
    OUT p_message JSON
) BEGIN

	DECLARE last_id_atividade_personalizada INT;
    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

    IF NOT EXISTS (SELECT 1 FROM tb_usuario where id = p_id_usuario) THEN
    
        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = p_id_paciente) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);

    ELSEIF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario AND id_tipo_usuario = 1) THEN

        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
	
	ELSE
    
		INSERT INTO tb_atividade_personalizada(
			
			comportamento,
            valor_meses,
            id_habilidade,
            id_usuario
            
        ) VALUES (
        
			p_comportamento,
            p_valor_meses,
            p_id_habilidade,
            p_id_usuario
        
        );
        
        SET last_id_atividade_personalizada = LAST_INSERT_ID();
        
        INSERT INTO tb_atividade(
        
			id_paciente,
            id_atividade_personalizada
            
        ) VALUES (
			
            p_id_paciente,
            last_id_atividade_personalizada
            
        );
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 201,
            'message', 'Cadastro bem sucedido!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
        
        call prc_atividades(p_id_paciente, p_id_habilidade, @resultAtividade);
    
    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualiza_atividade_personalizada(
	IN p_id_atividade INT,
    IN p_id_usuario INT,
    IN p_comportamento VARCHAR(300),
    IN p_valor_meses INT,
    OUT p_message JSON
) BEGIN

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();
    
    IF NOT EXISTS(SELECT 1 FROM tb_usuario WHERE id = p_id_usuario) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS(
    
    SELECT 1 FROM tb_atividade_personalizada WHERE id = (
		SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade
    ) AND id_usuario = p_id_usuario ) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
    
    ELSE 
    
		UPDATE tb_atividade_personalizada
        SET 
			comportamento = p_comportamento,
            valor_meses = p_valor_meses
		WHERE id = (
			SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade
        );
    
		SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
		call prc_atividades(
		(SELECT id_paciente FROM tb_atividade WHERE id_atividade_personalizada = (SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade)), 
		(SELECT id_habilidade FROM tb_atividade_personalizada WHERE id = (SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade)),
        @resultAtividade);
    
	END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_delete_atividade(
    IN p_id_usuario INT,
    IN p_id_paciente INT,
    IN p_id_atividade INT,
    OUT p_message JSON
) BEGIN

    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();
    
	IF NOT EXISTS (SELECT 1 FROM tb_usuario WHERE id = p_id_usuario) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS (SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
        
	ELSEIF NOT EXISTS (
    
		SELECT 1 
        FROM tb_atividade atividade
        INNER JOIN tb_usuario_paciente relacao ON relacao.id_paciente = atividade.id_paciente
        WHERE atividade.id = p_id_atividade 
          AND atividade.id_paciente = p_id_paciente 
          AND relacao.id_usuario = p_id_usuario
    
	) THEN 
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
        
	ELSE
    
		IF ((SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade) IS NOT NULL) THEN
        
			call prc_atividades(p_id_paciente, 
			( SELECT id_atividade_personalizada FROM tb_atividade WHERE id = p_id_atividade )
			, @resultAtividade);
            
		ELSE
        
			call prc_atividades(p_id_paciente, 
			( SELECT id_atividade_portage FROM tb_atividade WHERE id = p_id_atividade )
			, @resultAtividade);
        
        END IF;
    
		DELETE FROM tb_atividade WHERE id = p_id_atividade;
		
        SET p_message = JSON_OBJECT(
            'status', TRUE,
            'status_code', 200,
            'message', 'Atividade excluída com sucesso.',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
    END IF;
    

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atividades(
	IN p_id_paciente INT,
    IN p_id_habilidade INT,
    OUT p_message JSON
) BEGIN

	DECLARE atividades JSON;

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS(SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
		
        SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_habilidade WHERE id = p_id_habilidade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
	ELSE
    
		-- portage
		SELECT JSON_ARRAYAGG(
			JSON_OBJECT(
				
                'id_atividade', id_atividade,
                'concluida', concluida,
                'numero_questao', numero_questao,
                'comportamento', comportamento,
                'habilidade', JSON_OBJECT(
					'id_habilidade', id_habilidade,
					'nome_habilidade', nome_habilidade
				)
            )
        )
        FROM vw_todas_atividades
        WHERE id_paciente = p_id_paciente
        AND id_habilidade = p_id_habilidade
		INTO atividades;
        
        SET p_message = JSON_OBJECT(
			
			'status', TRUE,
			'status_code', '200',
			'message', 'Requisição feita com sucesso!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
			'data', atividades
            
        );
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atualiza_status_atividade(
	IN p_id_atividade INT,
    OUT p_message JSON
) BEGIN

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS(SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
		
    ELSE
		
		UPDATE tb_atividade SET
			concluida = TRUE
		WHERE id = p_id_atividade;
        
        IF EXISTS (
        
			SELECT 1 FROM tb_atividade WHERE id = p_id_atividade AND id_atividade_portage IS NOT NULL
        
        ) THEN
        
			UPDATE tb_formulario SET
				id_resposta = 1
            WHERE id_paciente = (SELECT id_paciente FROM tb_atividade WHERE id = p_id_atividade) -- Retorna o id do paciente que essa atividade pertence
			AND id_atividade_portage = (SELECT id_atividade_portage FROM tb_atividade WHERE id = p_id_atividade);
        
        END IF;
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
		);
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atividade(

	IN p_id_atividade INT,
    IN p_id_usuario INT,
    OUT p_message JSON

) BEGIN

	DECLARE return_atividade JSON;
	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS(SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
    
    ELSEIF NOT EXISTS(SELECT 1 FROM tb_usuario_paciente WHERE id_usuario = p_id_usuario AND id_paciente = (
		SELECT id_paciente FROM tb_atividade WHERE id = p_id_atividade
    )) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 401,
			'message', 'Não foi possível processar a requisição pois faltam credenciais válidas!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
			
		);
    
    ELSE
		
		SELECT JSON_OBJECT(
			'id_atividade', id_atividade,
            'id_paciente', id_paciente,
            'concluida', concluida,
            'numero_questao', numero_questao,
            'comportamento', comportamento,
            'habilidade', JSON_ARRAYAGG(
				JSON_OBJECT(
					'id_habilidade', id_habilidade,
					'nome_habilidade', nome_habilidade
                )
            )
            
        ) FROM vw_todas_atividades 
        WHERE id_atividade = p_id_atividade
        GROUP BY id_atividade, id_paciente, concluida, numero_questao, comportamento, id_habilidade, nome_habilidade
        INTO return_atividade;
        
        SET p_message = JSON_OBJECT(
			'status', TRUE,
            'status_code', 200,
            'message', 'Item atualizado com sucesso!!!',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', return_atividade
		);
    
    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_atividade_portage_nao_desenvolvida(
	
    IN p_id_paciente INT,
    IN p_id_habilidade INT,
	OUT p_message JSON
    
) BEGIN

	DECLARE return_atividades JSON;
	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS(SELECT 1 FROM tb_paciente WHERE id = p_id_paciente) THEN
		
		SET p_message = JSON_OBJECT(
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
	
	ELSEIF NOT EXISTS(SELECT 1 FROM tb_habilidade WHERE id = p_id_habilidade) THEN
    
		SET p_message = JSON_OBJECT(
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        );
    
	ELSE
		
		SELECT JSON_ARRAYAGG(
			JSON_OBJECT(
				
                'id_atividade_portage', id_atividade_portage,
                'numero_questao', numero_questao,
                'comportamento', comportamento,
                'habilidade', JSON_ARRAY(
					JSON_OBJECT(
						'id_habilidade', id_habilidade,
						'nome_habilidade', nome_habilidade
                    )
                ),
                'id_faixa_idade', id_faixa_idade
            )
        ) FROM vw_atividade_portage_nao_desenvolvida
		WHERE id_habilidade = p_id_habilidade AND id_paciente = p_id_paciente
        ORDER BY id_atividade_portage, numero_questao, comportamento, id_habilidade, nome_habilidade, id_faixa_idade
        INTO return_atividades;
        
		
		SET p_message = JSON_OBJECT(
				'status', TRUE,
				'status_code', 200,
				'message', 'Item atualizado com sucesso!!!',
				'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
				'data', return_atividades
			);
		
    
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_inserir_tentativa(
    IN p_id_tipo_aplicacao INT,
    IN p_id_atividade INT,
    IN p_resultado BOOLEAN, 
    IN p_observacao VARCHAR(1500),
    IN p_data_tentativa DATE,
    OUT p_message JSON
) BEGIN
    
    DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

   IF NOT EXISTS(SELECT 1 FROM tb_tipo_aplicacao WHERE id = p_id_tipo_aplicacao) THEN
		SELECT * FROM tb_tipo_aplicacao;
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
   
   ELSEIF NOT EXISTS (SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
		SELECT * FROM tb_atividade;
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
   
   ELSE
   
		INSERT INTO tb_tentativa(
			
			id_atividade,
            id_tipo_aplicacao,
            observacao,
            data_tentativa,
            resultado
            
        ) VALUES (
			
            p_id_atividade,
            p_id_tipo_aplicacao,
            p_observacao,
            p_data_tentativa,
            p_resultado
            
        );
        
        SET p_message = JSON_OBJECT(
        
			'status', TRUE,
			'status_code', 201,
			'message', 'Inserção feita com sucesso!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
        
        CALL prc_tentativa(p_id_atividade, @resultTentativa);
   
   END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE prc_tentativa(

	IN p_id_atividade INT,
    OUT p_message JSON

) BEGIN

	DECLARE data_hoje DATE;
    SET data_hoje = CURDATE();

	IF NOT EXISTS (SELECT 1 FROM tb_atividade WHERE id = p_id_atividade) THEN
    
		SET p_message = JSON_OBJECT(
        
			'status', FALSE,
			'status_code', 404,
			'message', 'Não foram encontrados dados de retorno!!!',
			'date', DATE_FORMAT(data_hoje, '%d/%m/%Y')
        
        );
		
    ELSE
        
		SET p_message = JSON_OBJECT(
        
			'status', TRUE,
            'status_code', 200,
            'message', 'Requisição bem sucedida',
            'date', DATE_FORMAT(data_hoje, '%d/%m/%Y'),
            'data', (SELECT json_arrayagg(
				json_object(
                'id_atividade', id_atividade,
                'id_tentativa', id_tentativa,
                'resultado', resultado,
                'data_tentativa', data_tentativa,
                'observacao', observacao,
                'auxilio', auxilio,
                'numero_questao', numero_questao,
                'comportamento', comportamento,
				'habilidade', json_object(
					'id_habilidade', id_habilidade,
                    'nome_habilidade', nome_habilidade
                )
            )
        ) FROM vw_tentativas 
        WHERE id_atividade = p_id_atividade)
        
        );
    
    END IF;


END $$ 

DELIMITER ;

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