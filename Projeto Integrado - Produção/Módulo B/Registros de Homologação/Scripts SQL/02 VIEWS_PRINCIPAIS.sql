--------------------------------------------------------
--  Arquivo criado - Domingo-Setembro-04-2022   
--------------------------------------------------------

------------------------------------------------------------------------------------------------
--  *** VIEWS PRINCIPAIS SOBRE AS QUAIS RODAM AS CONSULTAS SQL DOS REGISTROS DE HOMOLOGAÇÃO ***
------------------------------------------------------------------------------------------------

--------------------------------------------------------
--  DDL for View VW_CLASSIFICACAO_RAIO_X
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_CLASSIFICACAO_RAIO_X" ("TORNEIO", "CLUBE", "CLASSIFICACAO", "JOGOS", "PONTOS", "VITORIAS", "EMPATES", "DERROTAS", "GOLS_MARCADOS", "GOLS_SOFRIDOS", "SALDO_GOLS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select tb1.torneio, clube, ordem - (min_ordem - 1) as classificacao, jogos, pontos, vitorias, empates,
        derrotas, gols_marcados, gols_sofridos,
        saldo_gols
from VW_RAIO_X_ORDEM tb1 inner join VW_MIN_ORDEM tb2 on tb1.torneio = tb2.torneio
order by tb1.torneio, ordem
;
--------------------------------------------------------
--  DDL for View VW_COMPLETO_RAIO_X2
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_COMPLETO_RAIO_X2" ("TORNEIO", "CLUBE", "CLUBE_ADVERSARIO", "ARENA", "FORMACAO", "FORMACAO_ADVESARIO", "TURNO_DIA", "CONDICAO", "JOGOS", "PONTOS", "VITORIAS", "EMPATES", "DERROTAS", "GOLS_MARCADOS", "GOLS_SOFRIDOS", "SALDO_GOLS", "CARTOES_AMARELOS", "CARTOES_VERMELHOS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  (
    select cp.torneio, jg.mandante as clube, jg.visitante as clube_adversario,
           jg.arena, jg.formacao_mandante as formacao, jg.formacao_visitante as formacao_advesario, 
           (CASE
               WHEN TO_NUMBER(SUBSTR(jg.hora,1,2)) < 12 THEN 'MANHÃ'
               WHEN TO_NUMBER(SUBSTR(jg.hora,1,2)) >= 12 and TO_NUMBER(SUBSTR(jg.hora,1,2)) < 18  THEN 'TARDE'
               ELSE 'NOITE'
               END) as turno_dia,     
           'MANDANTE' as condicao, count(*) as jogos,
           sum(
               CASE
               WHEN jg.mandante_placar > jg.visitante_placar THEN 3
               WHEN jg.mandante_placar = jg.visitante_placar THEN 1
               ELSE 0
               END               
               ) as pontos, 
           sum(
               CASE
               WHEN jg.mandante_placar > jg.visitante_placar THEN 1               
               ELSE 0
               END               
               ) as vitorias,
           sum(
               CASE
               WHEN jg.mandante_placar = jg.visitante_placar THEN 1
               ELSE 0
               END               
               ) as empates,  
           sum(
               CASE
               WHEN jg.mandante_placar < jg.visitante_placar THEN 1
               ELSE 0
               END               
               ) as derrotas,  
           sum(jg.mandante_placar) as gols_marcados,
           sum(jg.visitante_placar) as gols_sofridos,
           sum(jg.mandante_placar - jg.visitante_placar) as saldo_gols,
           sum(est.cartao_amarelo) as cartoes_amarelos,
           sum(est.cartao_vermelho) as cartoes_vermelhos
    from TMP_CAMPEONATO_BRASILEIRO_FULL jg inner join TMP_CAMPEONATO_BRASILEIRO_PONTOS_CORRIDOS_PERIODO cp 
             on (TO_DATE(TO_CHAR(jg.DATA, 'YYYY-MM-DD'), 'YYYY-MM-DD') >= TO_DATE(cp.inicio,'DD/MM/YYYY') and 
                TO_DATE(TO_CHAR(jg.DATA, 'YYYY-MM-DD'), 'YYYY-MM-DD') <= TO_DATE(cp.fim,'DD/MM/YYYY') )       

                                           inner join TMP_CAMPEONATO_BRASILEIRO_ESTATISTICAS_FULL est on jg.id = est.partida_id and
                                                      jg.mandante = est.clube

    group by cp.torneio, jg.mandante, jg.visitante, jg.arena, jg.formacao_mandante, jg.formacao_visitante,
              (CASE
               WHEN TO_NUMBER(SUBSTR(jg.hora,1,2)) < 12 THEN 'MANHÃ'
               WHEN TO_NUMBER(SUBSTR(jg.hora,1,2)) >= 12 and TO_NUMBER(SUBSTR(jg.hora,1,2)) < 18  THEN 'TARDE'
               ELSE 'NOITE'
               END)

    union

    select cp.torneio, jg.visitante as clube, jg.mandante as clube_adversario,
           jg.arena, jg.formacao_visitante as formacao, jg.formacao_mandante as formacao_advesario, 
           (CASE
               WHEN TO_NUMBER(SUBSTR(jg.hora,1,2)) < 12 THEN 'MANHÃ'
               WHEN TO_NUMBER(SUBSTR(jg.hora,1,2)) >= 12 and TO_NUMBER(SUBSTR(jg.hora,1,2)) < 18  THEN 'TARDE'
               ELSE 'NOITE'
               END) as turno_dia,     
           'VISITANTE' as condicao, count(*) as jogos,
           sum(
               CASE
               WHEN jg.mandante_placar < jg.visitante_placar THEN 3
               WHEN jg.mandante_placar = jg.visitante_placar THEN 1
               ELSE 0
               END               
               ) as pontos, 
           sum(
               CASE
               WHEN jg.mandante_placar < jg.visitante_placar THEN 1               
               ELSE 0
               END               
               ) as vitorias,
           sum(
               CASE
               WHEN jg.mandante_placar = jg.visitante_placar THEN 1
               ELSE 0
               END               
               ) as empates,  
           sum(
               CASE
               WHEN jg.mandante_placar > jg.visitante_placar THEN 1
               ELSE 0
               END               
               ) as derrotas,  
           sum(jg.visitante_placar) as gols_marcados,
           sum(jg.mandante_placar) as gols_sofridos,
           sum(jg.visitante_placar - jg.mandante_placar) as saldo_gols,
           sum(est.cartao_amarelo) as cartoes_amarelos,
           sum(est.cartao_vermelho) as cartoes_vermelhos
    from TMP_CAMPEONATO_BRASILEIRO_FULL jg inner join TMP_CAMPEONATO_BRASILEIRO_PONTOS_CORRIDOS_PERIODO cp 
             on (TO_DATE(TO_CHAR(jg.DATA, 'YYYY-MM-DD'), 'YYYY-MM-DD') >= TO_DATE(cp.inicio,'DD/MM/YYYY') and 
                TO_DATE(TO_CHAR(jg.DATA, 'YYYY-MM-DD'), 'YYYY-MM-DD') <= TO_DATE(cp.fim,'DD/MM/YYYY') )       

                                           inner join TMP_CAMPEONATO_BRASILEIRO_ESTATISTICAS_FULL est on jg.id = est.partida_id and
                                                      jg.visitante = est.clube

    group by cp.torneio, jg.visitante, jg.mandante, jg.arena, jg.formacao_visitante, jg.formacao_mandante,
              (CASE
               WHEN TO_NUMBER(SUBSTR(jg.hora,1,2)) < 12 THEN 'MANHÃ'
               WHEN TO_NUMBER(SUBSTR(jg.hora,1,2)) >= 12 and TO_NUMBER(SUBSTR(jg.hora,1,2)) < 18  THEN 'TARDE'
               ELSE 'NOITE'
               END)


)
;
