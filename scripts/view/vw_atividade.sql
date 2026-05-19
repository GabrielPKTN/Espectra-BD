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