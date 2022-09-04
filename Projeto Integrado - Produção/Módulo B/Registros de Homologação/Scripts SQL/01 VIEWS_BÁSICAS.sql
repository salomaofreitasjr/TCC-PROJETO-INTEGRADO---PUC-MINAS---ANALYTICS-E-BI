--------------------------------------------------------
--  Arquivo criado - Domingo-Setembro-04-2022   
--------------------------------------------------------

--------------------------------------------------------
--  *** VIEWS BÁSICAS PARA ORGANIZAÇÃO DOS DADOS ***
--------------------------------------------------------

--------------------------------------------------------
--  DDL for View VW_RAIO_X
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_RAIO_X" ("TORNEIO", "CLUBE", "JOGOS", "PONTOS", "VITORIAS", "EMPATES", "DERROTAS", "GOLS_MARCADOS", "GOLS_SOFRIDOS", "SALDO_GOLS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select torneio, clube, sum(jogos) as jogos, sum(pontos) as pontos, sum(vitorias) as vitorias, sum(empates) as empates,
       sum(derrotas) as derrotas, sum(gols_marcados) as gols_marcados, sum(gols_sofridos) as gols_sofridos,
       sum(saldo_gols) as saldo_gols
from
(
    select cp.torneio, jg.mandante as clube, 'MANDANTE' as condicao, count(*) as jogos,
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
           sum(jg.mandante_placar - jg.visitante_placar) as saldo_gols
    from TMP_CAMPEONATO_BRASILEIRO_FULL jg inner join TMP_CAMPEONATO_BRASILEIRO_PONTOS_CORRIDOS_PERIODO cp 
            on (TO_DATE(TO_CHAR(jg.DATA, 'YYYY-MM-DD'), 'YYYY-MM-DD') >= TO_DATE(cp.inicio,'DD/MM/YYYY') and 
                TO_DATE(TO_CHAR(jg.DATA, 'YYYY-MM-DD'), 'YYYY-MM-DD') <= TO_DATE(cp.fim,'DD/MM/YYYY') )                        
    group by cp.torneio, jg.mandante

    union

    select cp.torneio, jg.visitante as clube, 'VISITANTE' as condicao, count(*) as jogos,
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
           sum(jg.visitante_placar - jg.mandante_placar) as saldo_gols
    from TMP_CAMPEONATO_BRASILEIRO_FULL jg inner join TMP_CAMPEONATO_BRASILEIRO_PONTOS_CORRIDOS_PERIODO cp 
            on (TO_DATE(TO_CHAR(jg.DATA, 'YYYY-MM-DD'), 'YYYY-MM-DD') >= TO_DATE(cp.inicio,'DD/MM/YYYY') and 
                TO_DATE(TO_CHAR(jg.DATA, 'YYYY-MM-DD'), 'YYYY-MM-DD') <= TO_DATE(cp.fim,'DD/MM/YYYY') )                        
    group by cp.torneio, jg.visitante



)
group by torneio, clube

order by torneio, pontos desc, vitorias desc, saldo_gols desc, gols_marcados desc
;
--------------------------------------------------------
--  DDL for View VW_RAIO_X_ORDEM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_RAIO_X_ORDEM" ("TORNEIO", "CLUBE", "ORDEM", "JOGOS", "PONTOS", "VITORIAS", "EMPATES", "DERROTAS", "GOLS_MARCADOS", "GOLS_SOFRIDOS", "SALDO_GOLS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT torneio, clube, rownum as ordem, jogos, pontos, vitorias, empates,
        derrotas, gols_marcados, gols_sofridos,
        saldo_gols 
       FROM VW_RAIO_X
;

--------------------------------------------------------
--  DDL for View VW_MIN_ORDEM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_MIN_ORDEM" ("TORNEIO", "MIN_ORDEM") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT torneio, min(ORDEM) as min_ordem
FROM VW_RAIO_X_ORDEM
group by torneio
;

