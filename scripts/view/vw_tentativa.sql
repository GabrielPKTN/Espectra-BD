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