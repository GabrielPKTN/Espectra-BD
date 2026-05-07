-- ----------------------------------
-- VIEWS
-- ----------------------------------

-- VIEW QUE RETORNA INFORMAÇÕES DO FORMULÁRIO DE UM PACIENTE
CREATE VIEW vw_formulario_paciente_id AS
SELECT p.id AS id_paciente,
    JSON_ARRAYAGG(
		JSON_OBJECT(
			'id', f.id,
            'nome', p.nome,
            'numero_questao', ap.numero_questao,
            'questao', ap.questao,
            'valor_atividade', ap.valor_atividade,
            'habilidade', h.nome,
				'faixa_idade', JSON_OBJECT(
					'idade_min', fi.idade_min,
                    'idade_max', fi.idade_max
                ),
			'resposta', rf.alternativa
        )
    ) AS questoes

FROM tb_formulario f
INNER JOIN tb_paciente p 
    ON p.id = f.id_paciente 
INNER JOIN tb_atividade_portage ap 
    ON ap.id = f.id_atividade_portage
LEFT JOIN tb_resposta_formulario rf 
    ON rf.id = f.id_resposta
INNER JOIN tb_habilidade h 
    ON h.id = ap.id_habilidade
INNER JOIN tb_faixa_idade fi 
    ON fi.id = ap.id_faixa_idade
    
GROUP BY p.id;

-- VIEW PARA RETORNAR O FORMULÁRIO DE UM PACIENTE PELO ID E SUAS RESPOSTAS
CREATE VIEW vw_resposta_formulario_paciente_id AS
SELECT p.id AS id_paciente,
rf.alternativa AS resposta,
	JSON_ARRAYAGG(
		JSON_OBJECT(
			'id', p.id,
            'nome', p.nome,
            'numero_questao', ap.numero_questao,
            'questao', ap.questao,
            'valor_atividade', ap.valor_atividade,
            'habilidade', h.nome,
				'faixa_idade', JSON_OBJECT(
					'idade_min', fi.idade_min,
                    'idade_max', fi.idade_max
                ),
			'resposta', rf.alternativa
        )
    ) AS questoes
    
FROM tb_formulario f
INNER JOIN tb_paciente p 
    ON p.id = f.id_paciente 
INNER JOIN tb_atividade_portage ap 
    ON ap.id = f.id_atividade_portage
LEFT JOIN tb_resposta_formulario rf 
    ON rf.id = f.id_resposta
INNER JOIN tb_habilidade h 
    ON h.id = ap.id_habilidade
INNER JOIN tb_faixa_idade fi 
    ON fi.id = ap.id_faixa_idade
    
GROUP BY p.id, rf.alternativa;

-- VIEW PARA RETORNAR OS DADOS DE UMA TENTATIVA PELO ID
CREATE VIEW vw_tentativa_id AS

SELECT 
    t.id AS id_tentativa,

    JSON_OBJECT(
        'id', t.id,
        'resultado', t.resultado,
        'data', t.data_tentativa,
        'observacao', t.observacao,
        'nivel_auxilio', ti.alternativa,

        'atividade',

        JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', ap.id,
                'questao', ap.questao,
                'valor_meses', ap.valor_meses,
                'psicopedagogo', p.nome
            )
        )

    ) AS tentativa

FROM tb_tentativa t

INNER JOIN tb_tipo_aplicacao ti 
    ON ti.id = t.id_tipo_aplicacao
INNER JOIN tb_atividade_personalizada ap 
    ON ap.id = t.id_atividade
INNER JOIN tb_psicopedagogo p 
    ON p.id = ap.id_psicopedagogo

GROUP BY t.id;