--------------------------------------------------------
--  Arquivo criado - Domingo-Setembro-04-2022   
--------------------------------------------------------


----------------------------------------------------------------------
--  *** VIEWS COM AS CONSULTAS SQL DOS REGISTROS DE HOMOLOGAÇÃO ***
----------------------------------------------------------------------

--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_01
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_01" ("TORNEIO", "CLUBE", "PONTOS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select torneio, clube, pontos
    from VW_CLASSIFICACAO_RAIO_X
    where classificacao = 1
    order by torneio desc
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_02
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_02" ("CLUBE", "QTD") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select clube, count(*) as qtd from
        (
        select * from VW_CLASSIFICACAO_RAIO_X
        where classificacao = 1
        order by torneio desc
        )
    group by clube
    order by qtd desc
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_03
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_03" ("ESTADO", "QTD", "PERC") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select est.nome as estado, 
        count(*) as qtd, 
        --sum(count(*)) over() total_cnt,
        round(100*(count(*) / sum(count(*)) over ()),2) perc

    from
        (
        select * from VW_CLASSIFICACAO_RAIO_X
        where classificacao = 1
        order by torneio desc
        ) rx inner join tb_stg_correspondencia_clube cc on rx.clube = cc.nome_sujo
            inner join tb_clube c on cc.cod_clube_correspondente = c.cod_clube 
            inner join tb_cidade cid on c.cod_cidade = cid.cod_cidade
            inner join tb_estado est on cid.cod_estado = est.cod_estado
    group by est.nome
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_04
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_04" ("CIDADE", "NUM_VITORIAS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select cid.nome as cidade, sum(vitorias) as num_vitorias
    from VW_CLASSIFICACAO_RAIO_X rx 
                inner join tb_stg_correspondencia_clube cc on rx.clube = cc.nome_sujo
                inner join tb_clube c on cc.cod_clube_correspondente = c.cod_clube 
                inner join tb_cidade cid on c.cod_cidade = cid.cod_cidade
    group by cid.nome
    order by num_vitorias desc
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_05
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_05" ("CLUBE", "NUM_GOLS_SOFRIDOS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select clube, sum(gols_sofridos) as num_gols_sofridos
    from VW_CLASSIFICACAO_RAIO_X                
    group by clube
    order by num_gols_sofridos desc
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_06
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_06" ("ESTADO", "NUM_CARTOES_AMARELOS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select est.sigla as estado, sum(cartao_amarelo) as num_cartoes_amarelos
    from TMP_CAMPEONATO_BRASILEIRO_ESTATISTICAS_FULL est_full
            inner join tb_stg_correspondencia_clube cc on est_full.clube = cc.nome_sujo
            inner join tb_clube c on cc.cod_clube_correspondente = c.cod_clube 
            inner join tb_cidade cid on c.cod_cidade = cid.cod_cidade
            inner join tb_estado est on cid.cod_estado = est.cod_estado
    group by est.sigla
    order by num_cartoes_amarelos desc
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_07
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_07" ("CLUBE", "TORNEIO", "NUM_GOLS_MARCADOS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select rx.clube, rx.torneio, sum(gols_marcados) as num_gols_marcados
    from VW_COMPLETO_RAIO_X2 rx
            inner join tb_stg_correspondencia_estadio_2 ce on rx.arena = ce.nome_sujo
            inner join tb_estadio e on ce.cod_estadio_correspondente = e.cod_estadio
            inner join tb_cidade cid_est on e.cod_cidade = cid_est.cod_cidade
            inner join tb_estado est_est on cid_est.cod_estado = est_est.cod_estado
            inner join tb_regiao reg_est on est_est.cod_regiao = reg_est.cod_regiao

            inner join tb_stg_correspondencia_clube cc on rx.clube_adversario = cc.nome_sujo
            inner join tb_clube c on cc.cod_clube_correspondente = c.cod_clube 
            inner join tb_cidade cid_adv on c.cod_cidade = cid_adv.cod_cidade
            inner join tb_estado est_adv on cid_adv.cod_estado = est_adv.cod_estado
            inner join tb_regiao reg_adv on est_adv.cod_regiao = reg_adv.cod_regiao
    where rx.clube = 'Flamengo' and rx.condicao = 'VISITANTE' and reg_est.nome = 'Nordeste' and 
          rx.turno_dia = 'NOITE' AND reg_adv.nome = 'Nordeste'
    group by rx.clube, rx.torneio
    --having rx.clube = 'Flamengo'
    order by rx.torneio
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_08
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_08" ("CLUBE", "SIGLA", "NUM_DERROTAS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select rx.clube, est_est.sigla, sum(derrotas) as num_derrotas
    from VW_COMPLETO_RAIO_X2 rx
            inner join tb_stg_correspondencia_estadio_2 ce on rx.arena = ce.nome_sujo
            inner join tb_estadio e on ce.cod_estadio_correspondente = e.cod_estadio
            inner join tb_cidade cid_est on e.cod_cidade = cid_est.cod_cidade
            inner join tb_estado est_est on cid_est.cod_estado = est_est.cod_estado
            inner join tb_regiao reg_est on est_est.cod_regiao = reg_est.cod_regiao

            inner join tb_stg_correspondencia_clube cc on rx.clube_adversario = cc.nome_sujo
            inner join tb_clube c on cc.cod_clube_correspondente = c.cod_clube 
            inner join tb_cidade cid_adv on c.cod_cidade = cid_adv.cod_cidade
            inner join tb_estado est_adv on cid_adv.cod_estado = est_adv.cod_estado
            inner join tb_regiao reg_adv on est_adv.cod_regiao = reg_adv.cod_regiao
    where rx.clube = 'Flamengo' and (rx.torneio >='BRA2018' and rx.torneio <= 'BRA2021') and reg_adv.nome = 'Sudeste' and rx.condicao = 'MANDANTE' 
    group by rx.clube, est_est.sigla
    order by num_derrotas desc
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_09
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_09" ("CLUBE", "ESTADIO", "NUM_EMPATES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select rx.clube, e.nome as estadio, sum(empates) as num_empates
    from VW_COMPLETO_RAIO_X2 rx
            inner join tb_stg_correspondencia_estadio_2 ce on rx.arena = ce.nome_sujo
            inner join tb_estadio e on ce.cod_estadio_correspondente = e.cod_estadio
            inner join tb_cidade cid_est on e.cod_cidade = cid_est.cod_cidade
            inner join tb_estado est_est on cid_est.cod_estado = est_est.cod_estado
            inner join tb_regiao reg_est on est_est.cod_regiao = reg_est.cod_regiao

            inner join tb_stg_correspondencia_clube cc on rx.clube_adversario = cc.nome_sujo
            inner join tb_clube c on cc.cod_clube_correspondente = c.cod_clube 
            inner join tb_cidade cid_adv on c.cod_cidade = cid_adv.cod_cidade
            inner join tb_estado est_adv on cid_adv.cod_estado = est_adv.cod_estado
            inner join tb_regiao reg_adv on est_adv.cod_regiao = reg_adv.cod_regiao
    where rx.clube = 'Flamengo' and rx.condicao = 'VISITANTE' 
    group by rx.clube, e.nome
    order by num_empates desc
;
--------------------------------------------------------
--  DDL for View VW_REG_HOMOLOG_10
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW "FUT_BRASIL"."VW_REG_HOMOLOG_10" ("CLUBE", "ESTADO_ADV", "NUM_CARTOES_VERMELHOS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select rx.clube, est_adv.nome as estado_adv, sum(cartoes_vermelhos) as num_cartoes_vermelhos
    from VW_COMPLETO_RAIO_X2 rx
            --inner join tb_stg_correspondencia_estadio_2 ce on rx.arena = ce.nome_sujo
            --inner join tb_estadio e on ce.cod_estadio_correspondente = e.cod_estadio
            --inner join tb_cidade cid_est on e.cod_cidade = cid_est.cod_cidade
            --inner join tb_estado est_est on cid_est.cod_estado = est_est.cod_estado
            --inner join tb_regiao reg_est on est_est.cod_regiao = reg_est.cod_regiao

            inner join tb_stg_correspondencia_clube cc on rx.clube_adversario = cc.nome_sujo
            inner join tb_clube c on cc.cod_clube_correspondente = c.cod_clube 
            inner join tb_cidade cid_adv on c.cod_cidade = cid_adv.cod_cidade
            inner join tb_estado est_adv on cid_adv.cod_estado = est_adv.cod_estado
            inner join tb_regiao reg_adv on est_adv.cod_regiao = reg_adv.cod_regiao
    where rx.clube = 'Flamengo'
    group by rx.clube, est_adv.nome
    order by num_cartoes_vermelhos desc
;
