-- ----------------------------------
-- INSERTS
-- ----------------------------------

INSERT INTO tb_responsavel (foto, nome, data_nascimento, telefone, email, senha) VALUES
('foto1.jpg', 'Carlos Silva', '1985-03-12', '(11)91234-5678', 'carlos.silva@email.com', 'senha123'),
('foto2.jpg', 'Mariana Souza', '1990-07-25', '(11)92345-6789', 'mariana.souza@email.com', 'senha456'),
('foto3.jpg', 'João Pereira', '1978-11-03', '(11)93456-7890', 'joao.pereira@email.com', 'senha789'),
('foto4.jpg', 'Fernanda Lima', '1995-01-18', '(11)94567-8901', 'fernanda.lima@email.com', 'senha101'),
('foto5.jpg', 'Ricardo Alves', '1982-09-30', '(11)95678-9012', 'ricardo.alves@email.com', 'senha202');


INSERT INTO tb_psicopedagogo (foto, nome, data_nascimento, telefone, email, senha) VALUES
('psico1.jpg', 'Ana Martins', '1980-05-14', '(11)91111-1111', 'ana.martins@email.com', 'senhaA123'),
('psico2.jpg', 'Bruno Carvalho', '1975-08-22', '(11)92222-2222', 'bruno.carvalho@email.com', 'senhaB456'),
('psico3.jpg', 'Camila Rodrigues', '1988-12-09', '(11)93333-3333', 'camila.rodrigues@email.com', 'senhaC789'),
('psico4.jpg', 'Diego Fernandes', '1992-03-27', '(11)94444-4444', 'diego.fernandes@email.com', 'senhaD101'),
('psico5.jpg', 'Eduarda Gomes', '1983-10-05', '(11)95555-5555', 'eduarda.gomes@email.com', 'senhaE202');



INSERT INTO tb_serie_escolar (serie) VALUES
('Maternal'),
('Jardim I'),
('Jardim II'),
('1º ano'),
('2º ano'),
('3º ano'),
('4º ano'),
('5º ano'),
('6º ano'),
('7º ano'),
('8º ano'),
('9º ano'),
('1º série do Ensino Médio'),
('2º série do Ensino Médio'),
('3º série do Ensino Médio');



INSERT INTO tb_grau_suporte (grau) VALUES
('1'),
('2'),
('3');



INSERT INTO tb_paciente (nome, data_nascimento, diagnostico, id_serie_escolar, id_grau_suporte, id_psicopedagogo) VALUES
('Lucas Andrade', '2015-04-10', 'TDAH', 4, 1, 1),
('Beatriz Oliveira', '2013-09-22', 'TEA', 6, 2, 2),
('Pedro Santos', '2011-01-30', 'Dislexia', 8, 1, 3),
('Juliana Costa', '2016-07-15', 'TDAH', 3, 2, 4),
('Rafael Mendes', '2010-12-05', 'TEA', 9, 3, 5);



INSERT INTO tb_resposta_formulario (alternativa) VALUES
('Sim'),
('Não'),
('Sim com mediação');


INSERT INTO tb_faixa_idade (idade_min, idade_max) VALUES
(0, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6);



INSERT INTO tb_status_atividade (status_atividade) VALUES
('Não iniciado'),
('Em andamento'),
('Concluído');


INSERT INTO tb_habilidade (nome) VALUES
('Socialização'),
('Linguagem'),
('Cognição'),
('Auto-Cuidados'),
('Desenvolvimento motor');



INSERT INTO tb_atividade_personalizada (questao, valor_meses, id_psicopedagogo, id_habilidade) VALUES
('Estende a mão em direção a um objeto oferecido', 6, 1, 6),
('Segue com o olhar um objeto em movimento', 4, 2, 7),
('Responde ao ser chamado pelo nome', 8, 3, 8),
('Imita gestos simples como bater palmas', 10, 4, 9),
('Segura objetos pequenos com as mãos', 5, 5, 10);



INSERT INTO tb_responsavel_paciente (id_responsavel, id_paciente) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);



INSERT INTO tb_atividade_portage (numero_questao, questao, id_faixa_idade, id_habilidade) VALUES
(1, 'Segue com os olhos um objeto em movimento lateral', 1, 6),
(2, 'Responde ao sorriso de um adulto conhecido', 2, 7),
(3, 'Aponta para objetos desejados quando solicitado', 3, 8),
(4, 'Imita ações simples realizadas por um adulto', 4, 9),
(5, 'Empilha dois ou mais blocos quando solicitado', 5, 10);



INSERT INTO tb_atividade (id_status_atividade, id_paciente, id_atividade_personalizada, id_atividade_portage) VALUES
(1, 1, 6, NULL),
(2, 2, NULL, 2),
(3, 3, 7, NULL),
(1, 4, NULL, 4),
(2, 5, 8, NULL);




INSERT INTO tb_tipo_aplicacao (alternativa) VALUES
('Auxílio total'),
('Auxílio parcial'),
('Independente');



INSERT INTO tb_tentativa (resultado, observacao, data_tentativa, id_tipo_aplicacao, id_atividade) VALUES
(TRUE, 'Realizou a atividade com auxílio mínimo', '2026-04-10', 3, 11),
(FALSE, 'Não conseguiu completar mesmo com apoio', '2026-04-11', 1, 12),
(TRUE, 'Executou parcialmente a tarefa solicitada', '2026-04-12', 2, 13),
(TRUE, 'Concluiu a atividade de forma independente', '2026-04-13', 3, 14),
(FALSE, 'Demonstrou dificuldade de compreensão da tarefa', '2026-04-14', 2, 15);



INSERT INTO tb_formulario (id_paciente, id_atividade_portage, id_resposta) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 1),
(5, 5, 2);



INSERT INTO tb_paciente_habilidade (anos_meses, id_paciente, id_habilidade) VALUES
(2.0, 1, 6),
(3.5, 2, 7),
(4.0, 3, 8),
(5.2, 4, 9),
(1.8, 5, 10);






