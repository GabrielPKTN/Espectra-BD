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