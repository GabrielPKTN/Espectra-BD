-- ----------------------------------
-- VIEWS
-- ----------------------------------

-- VIEW QUE RETORNA INFORMAÇÕES DO FORMULÁRIO DE UM PACIENTE
CREATE VIEW vw_formulario_paciente_id AS
SELECT p.id AS id_paciente,
JSON_OBJECT (
	'questao',
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
    )
) AS resposta

FROM tb_formulario f
INNER JOIN tb_paciente p 
    ON p.id = f.id_paciente 
INNER JOIN tb_atividade_portage ap 
    ON ap.id = f.id_atividade_portage
INNER JOIN tb_resposta_formulario rf 
    ON rf.id = f.id_resposta
INNER JOIN tb_habilidade h 
    ON h.id = ap.id_habilidade
INNER JOIN tb_faixa_idade fi 
    ON fi.id = ap.id_faixa_idade
    
GROUP BY p.id;