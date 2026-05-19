drop view vw_data_paciente;
drop view vw_diagnostico_paciente;
drop view vw_psicopedagogo_paciente;
drop view vw_responsavel_paciente;
drop view vw_habilidades_paciente;

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
    
SELECT * FROM vw_data_paciente WHERE id_paciente = 1;
SELECT * FROM vw_responsavel_paciente WHERE id_paciente = 1;
SELECT * FROM vw_diagnostico_paciente WHERE id_paciente = 1;
SELECT * FROM vw_psicopedagogo_paciente WHERE id_paciente = 1; 
SELECT * FROM vw_habilidades_paciente WHERE id_paciente = 1;