CREATE OR REPLACE EDITIONABLE FUNCTION "STG_BRASILEIRAO"."FC_CALCULA_CAMPOS_TB_STG_JOGO" RETURN integer
IS
  v_vitorias_mandante tb_stg_jogo.calc_vitorias_mandante%type;
  v_vitorias_visitante tb_stg_jogo.calc_vitorias_visitante%type;
  v_derrotas_mandante tb_stg_jogo.calc_derrotas_mandante%type;
  v_derrotas_visitante tb_stg_jogo.calc_derrotas_visitante%type;
  v_empates_mandante tb_stg_jogo.calc_empates_mandante%type;
  v_empates_visitante tb_stg_jogo.calc_empates_visitante%type;
  v_pontos_mandante tb_stg_jogo.calc_pontos_mandante%type;
  v_pontos_visitante tb_stg_jogo.calc_pontos_visitante%type;

  v_amarelo_mandante tb_stg_jogo.calc_cartoes_amarelos_mandante%type;
  v_vermelho_mandante tb_stg_jogo.calc_cartoes_amarelos_mandante%type;
  v_amarelo_visitante tb_stg_jogo.calc_cartoes_amarelos_mandante%type;
  v_vermelho_visitante tb_stg_jogo.calc_cartoes_amarelos_mandante%type;

  v_cod_mandante tb_stg_jogo.mandante%type;
  v_cod_visitante tb_stg_jogo.visitante%type;

  v_cod_estadio tb_stg_jogo.arena%type;

  v_hora integer;
  v_turno_dia tb_stg_jogo.calc_turno_dia%type;

  v_cod_campeonato tb_stg_jogo.calc_cod_campeonato%type;


  CURSOR jogos IS
    select *
    from TB_STG_JOGO        
    order by TO_NUMBER(id, '999999999');

BEGIN

    FOR jg IN jogos LOOP

        dbms_output.put_line('JOGO: ' || jg.ID || 'DATA: ' || jg.DATA);

        -- *** CALCULA AS MÉTRICAS ***
        if TO_NUMBER(jg.mandante_placar, '99') > TO_NUMBER(jg.visitante_placar, '99') then
            v_vitorias_mandante := 1;
            v_vitorias_visitante := 0;
            v_derrotas_mandante := 0;
            v_derrotas_visitante := 1;
            v_empates_mandante := 0;
            v_empates_visitante := 0;
            v_pontos_mandante := 3;
            v_pontos_visitante := 0;
        elsif TO_NUMBER(jg.mandante_placar, '99') < TO_NUMBER(jg.visitante_placar, '99') then
            v_vitorias_mandante := 0;
            v_vitorias_visitante := 1;
            v_derrotas_mandante := 1;
            v_derrotas_visitante := 0;
            v_empates_mandante := 0;
            v_empates_visitante := 0;
            v_pontos_mandante := 0;
            v_pontos_visitante := 3;
        else -- empate
            v_vitorias_mandante := 0;
            v_vitorias_visitante := 0;
            v_derrotas_mandante := 0;
            v_derrotas_visitante := 0;
            v_empates_mandante := 1;
            v_empates_visitante := 1;
            v_pontos_mandante := 1;
            v_pontos_visitante := 1;
        end if;


        -- *** CALCULA TURNO DIA
        v_hora := TO_NUMBER(SUBSTR(jg.HORA, 1, 2), '99');
        IF v_hora >= 18 
        THEN v_turno_dia := 'NOITE';
        ELSIF v_hora >= 12 THEN v_turno_dia := 'TARDE';
        ELSE v_turno_dia := 'MANHÃ';
        END IF;


        -- *** PEGA DADOS DOS CARTÕES ***
        SELECT cartoes_amarelos, cartoes_vermelhos
               into v_amarelo_mandante, v_vermelho_mandante
        FROM TB_STG_CARTOES 
        WHERE partida_id = jg.id and clube = jg.mandante;

        SELECT cartoes_amarelos, cartoes_vermelhos
                into v_amarelo_visitante, v_vermelho_visitante
        FROM TB_STG_CARTOES 
        WHERE partida_id = jg.id and clube = jg.visitante;


        -- *** PEGA CÓDIGO DO MANDANTE e VISITANTE DE CORRESPONDENCIA_CLUBE
        SELECT cc.COD_CLUBE_CORRESPONDENTE, cc2.COD_CLUBE_CORRESPONDENTE
                    INTO v_cod_mandante, v_cod_visitante
        FROM TB_STG_JOGO jogo LEFT JOIN TB_AUX_CORRESPONDENCIA_CLUBE cc 
                    ON (jogo.MANDANTE = cc.NOME_SUJO) -- OR jogo.MANDANTE = TO_CHAR(cc.COD_CLUBE_CORRESPONDENTE))
                                LEFT JOIN TB_AUX_CORRESPONDENCIA_CLUBE cc2 
                    ON (jogo.VISITANTE = cc2.NOME_SUJO)  -- OR jogo.VISITANTE = TO_CHAR(cc2.COD_CLUBE_CORRESPONDENTE))
        WHERE jogo.id = jg.id;


        -- *** PEGA CÓDIGO DO ESTADIO DE CORRESPONDENCIA_ESTADIO
        SELECT ce.COD_ESTADIO_CORRESPONDENTE 
                    INTO v_cod_estadio
        FROM TB_STG_JOGO jogo LEFT JOIN TB_AUX_CORRESPONDENCIA_ESTADIO ce 
                    ON (jogo.ARENA = ce.NOME_SUJO) -- OR jogo.ARENA = TO_CHAR(ce.COD_ESTADIO_CORRESPONDENTE))
        WHERE jogo.id = jg.id;        


        -- *** PEGA O CÓDIGO DO CAMPEONATO CORRESPONDENTE
        SELECT TORNEIO INTO v_cod_campeonato
        FROM TB_STG_CAMPEONATO
        WHERE TO_DATE(INICIO, 'DD/MM/YYYY') <= TO_DATE(jg.DATA, 'YYYY-MM-DD') AND TO_DATE(FIM, 'DD/MM/YYYY') >=TO_DATE(jg.DATA,  'YYYY-MM-DD');


        -- *** UPDATE COM OS VALORES OBTIDOS
        UPDATE tb_stg_jogo
        SET calc_vitorias_mandante = v_vitorias_mandante,
            calc_vitorias_visitante = v_vitorias_visitante,
            calc_derrotas_mandante = v_derrotas_mandante,
            calc_derrotas_visitante = v_derrotas_visitante,
            calc_empates_mandante = v_empates_mandante,
            calc_empates_visitante = v_empates_visitante,
            calc_pontos_mandante = v_pontos_mandante,
            calc_pontos_visitante = v_pontos_visitante,

            calc_cartoes_amarelos_mandante = v_amarelo_mandante,
            calc_cartoes_vermelhos_mandante = v_vermelho_mandante,
            calc_cartoes_amarelos_visitante = v_amarelo_visitante,
            calc_cartoes_vermelhos_visitante = v_vermelho_visitante,

            calc_cod_mandante = v_cod_mandante,
            calc_cod_visitante = v_cod_visitante,

            calc_cod_arena = v_cod_estadio,

            calc_turno_dia = v_turno_dia,

            calc_cod_campeonato = v_cod_campeonato


        WHERE id = jg.id;   

    END LOOP;


    RETURN 0;

END;