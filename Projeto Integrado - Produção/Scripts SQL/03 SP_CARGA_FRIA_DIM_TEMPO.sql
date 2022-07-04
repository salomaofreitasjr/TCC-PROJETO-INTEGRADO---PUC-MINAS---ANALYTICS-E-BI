CREATE OR REPLACE EDITIONABLE PROCEDURE "DW_BRASILEIRAO"."SP_CARGA_FRIA_DIM_TEMPO" 
(
    p_Ano_Inicial IN number,
    p_Ano_Final IN number,
    p_Apaga_Registros_Atuais IN char  -- S / N
)
AS

--/**************************************************************************************
-- **
-- ** PROCEDURE PARA CARGA DA TABELA TB_DIM_TEMPO
-- ** Autor      : SALOMÃO FREITAS JR.
-- ** Data       : 15/06/2022
-- ** Parâmetros : p_Ano_Inicial IN number             ano inicio da carga
-- **              p_Ano_Final IN number               ano final da carga
-- **              p_Apaga_Registros_Atuais IN char    S / N
-- **
-- **     
-- **************************************************************************************/

 vAnoMesDia tb_dim_tempo.pk_ano_mes_dia%TYPE;
 vDataDate tb_dim_tempo.data_date%TYPE;
 vDataStr tb_dim_tempo.data_str%TYPE;

 vAno tb_dim_tempo.ano%TYPE;

 vMesNum tb_dim_tempo.mes_num%TYPE;
 vMesDesc tb_dim_tempo.mes_desc%TYPE;
 vMesAbrev tb_dim_tempo.mes_abrev%TYPE;

 vAnoMesNum tb_dim_tempo.ano_mes_num%TYPE;
 vMesAnoNum tb_dim_tempo.mes_ano_num%TYPE;
 vMesAnoCompletoDesc tb_dim_tempo.mes_ano_completo_desc%TYPE;
 vMesAnoAbrevDesc tb_dim_tempo.mes_ano_abrev_desc%TYPE;

 vDia tb_dim_tempo.dia%TYPE;
 vDiaSemanaDesc tb_dim_tempo.dia_semana_desc%TYPE;
 vDiaSemanaNum tb_dim_tempo.dia_semana_num%TYPE;

 vFlagFinalSemana tb_dim_tempo.flag_final_semana%TYPE;

 vDataInicial date;
 vDataFinal date;
 vMesInt SMALLINT;
 vDiaInt SMALLINT;
 vContLinha0 SMALLINT;

BEGIN

    -- Verifica se vai pagar os registros atuais ou só carregar mais registros
    if p_Apaga_Registros_Atuais = 'S'
    then
        EXECUTE IMMEDIATE 'truncate table tb_dim_tempo';

        DBMS_OUTPUT.PUT_LINE('REGISTROS ATUAIS FORAM APAGADOS');
    else
        DBMS_OUTPUT.PUT_LINE('REGISTROS ATUAIS SERÃO MANTIDOS');
    end if;


    -- Seta as datas inicial e final, de acordo com os anos passados nos parâmetros
    vDataInicial := to_Date('01/01/' || p_Ano_Inicial || ' 00:00:00','dd/mm/yyyy HH24:MI:SS'); -- data inicial
    vDataFinal := to_Date('31/12/' || p_Ano_Final || ' 00:00:00','dd/mm/yyyy HH24:MI:SS'); -- data final

    DBMS_OUTPUT.PUT_LINE('NOVOS REGISTROS SERÃO INSERIDOS NA TABELA TB_DIM_TEMPO DESDE ' || to_char(vDataInicial,'dd/mm/yyyy') || ' ATÉ ' || to_char(vDataFinal,'dd/mm/yyyy'));
    DBMS_OUTPUT.PUT_LINE('INÍCIO DO PROCEDIMENTO DE CARGA: ' || to_char(SYSDATE,'dd/mm/yyyy - HH24:MI:SS'));

    -- LOOP PARA GERAR OS REGISTROS DA TABELA DIM_TEMPO
    -- DESDE A DATA INICIAL ATÉ A FINAL
    vDataDate := vDataInicial; -- inicializando para entrada no loop

    while vDataDate <= vDataFinal Loop
        --Seta os Valores do registro da data do loop
        vDataStr := trim(to_char(vDataDate,'dd/mm/yyyy'));
        vDia := trim(to_char(vDataDate,'dd'));
        vMesNum := trim(to_char(vDataDate,'mm'));
        vAno := trim(to_char(vDataDate,'yyyy'));

        vAnoMesDia := vAno || vMesNum || vDia;

        vMesInt := EXTRACT (MONTH FROM vDataDate);
        SELECT CASE vMesInt
                WHEN 1  THEN 'JANEIRO'
                WHEN 2  THEN 'FEVEREIRO'
                WHEN 3  THEN 'MARÇO'
                WHEN 4  THEN 'ABRIL'
                WHEN 5  THEN 'MAIO'
                WHEN 6  THEN 'JUNHO'
                WHEN 7  THEN 'JULHO'
                WHEN 8  THEN 'AGOSTO'
                WHEN 9  THEN 'SETEMBRO'
                WHEN 10 THEN 'OUTUBRO'
                WHEN 11 THEN 'NOVEMBRO'
                WHEN 12 THEN 'DEZEMBRO'
            END into vMesDesc from dual;


        SELECT CASE vMesInt
                WHEN 1  THEN 'JAN'
                WHEN 2  THEN 'FEV'
                WHEN 3  THEN 'MAR'
                WHEN 4  THEN 'ABR'
                WHEN 5  THEN 'MAI'
                WHEN 6  THEN 'JUN'
                WHEN 7  THEN 'JUL'
                WHEN 8  THEN 'AGO'
                WHEN 9  THEN 'SET'
                WHEN 10 THEN 'OUT'
                WHEN 11 THEN 'NOV'
                WHEN 12 THEN 'DEZ'
            END into vMesAbrev from dual;

        vAnoMesNum := vAno || vMesNum;
        vMesAnoNum := vMesNum || '/' || vAno;
        vMesAnoCompletoDesc := vMesDesc || '/' || vAno;
        vMesAnoAbrevDesc := vMesAbrev || '/' || vAno;

        vDiaSemanaNum :=  TO_CHAR(vDataDate,'D');
        SELECT CASE vDiaSemanaNum
                WHEN '1' THEN 'DOMINGO'
                WHEN '2' THEN 'SEGUNDA-FEIRA'
                WHEN '3' THEN 'TERÇA-FEIRA'
                WHEN '4' THEN 'QUARTA-FEIRA'
                WHEN '5' THEN 'QUINTA-FEIRA'
                WHEN '6' THEN 'SEXTA-FEIRA'
                WHEN '7' THEN 'SÁBADO'
            END into vDiaSemanaDesc from dual;

        /* Fim de semana S / N */
        IF vDiaSemanaNum = '1' or vDiaSemanaNum = '7' THEN
            vFlagFinalSemana := 'S';
        ELSE
            vFlagFinalSemana := 'N';
        END IF; 

        -- *** INSERE O REGISTRO ***
        --DBMS_OUTPUT.PUT_LINE('Data:  Valores dentro da procedure(1): ' ||pparam1 || '---' || pparam2 ||'---' || pparam3);
        insert into tb_dim_tempo (PK_ANO_MES_DIA, DATA_DATE, DATA_STR, ANO, MES_NUM, MES_DESC, MES_ABREV, ANO_MES_NUM, MES_ANO_NUM, MES_ANO_COMPLETO_DESC,
                    MES_ANO_ABREV_DESC, DIA, DIA_SEMANA_NUM, DIA_SEMANA_DESC, FLAG_FINAL_SEMANA)
            values (vAnoMesDia, vDataDate, vDataStr, vAno, vMesNum, vMesDesc, vMesAbrev, vAnoMesNum, vMesAnoNum, vMesAnoCompletoDesc, vMesAnoAbrevDesc, 
                    vDia, vDiaSemanaNum, vDiaSemanaDesc, vFlagFinalSemana);

        commit;

        -- Incrementa Data para próxima iteração
        vDataDate := vDataDate + 1; --adiciona um dia na data;

    end loop;

    -- insere uma linha sem data para associar na fato com registros sem a data
    -- mas só se a referida linha ainda não existir 
    -- (ela existirá caso seja apenas um complemento de carga, sem apagar os registros atuais)
    select count(*) into vContLinha0 from tb_dim_tempo where PK_ANO_MES_DIA = '-1'; 
    if vContLinha0 = 0
    then
        insert into tb_dim_tempo (PK_ANO_MES_DIA, DATA_DATE, DATA_STR, ANO, MES_NUM, MES_DESC, MES_ABREV, ANO_MES_NUM, MES_ANO_NUM, MES_ANO_COMPLETO_DESC,
                        MES_ANO_ABREV_DESC, DIA, DIA_SEMANA_NUM, DIA_SEMANA_DESC, FLAG_FINAL_SEMANA)
                values ('-1', to_Date('01/01/1800 00:00:00','dd/mm/yyyy HH24:MI:SS'), 'SEM DATA', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X');
    end if;


    DBMS_OUTPUT.PUT_LINE('CARGA DA TABELA TB_DIM_TEMPO CONCLUÍDA');
    DBMS_OUTPUT.PUT_LINE('FIM DO PROCEDIMENTO DE CARGA: ' || to_char(SYSDATE,'dd/mm/yyyy - HH24:MI:SS'));

END;