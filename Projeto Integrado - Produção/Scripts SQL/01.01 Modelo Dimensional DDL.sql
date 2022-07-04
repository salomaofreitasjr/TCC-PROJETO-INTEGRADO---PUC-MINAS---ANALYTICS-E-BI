
CREATE SEQUENCE SQ_SK_ESTADIO;

CREATE TABLE TB_DIM_ESTADIO (
                sk_estadio NUMBER NOT NULL,
                cod_estadio NUMBER NOT NULL,
                nome VARCHAR2(50) NOT NULL,
                cidade VARCHAR2(60) NOT NULL,
                estado VARCHAR2(60) NOT NULL,
                sigla_estado VARCHAR2(2) NOT NULL,
                regiao VARCHAR2(60) NOT NULL,
		versao NUMBER NOT NULL,
                data_inicio DATE NOT NULL,
                data_fim DATE,		
                CONSTRAINT TB_DIM_ESTADIO_PK PRIMARY KEY (sk_estadio)
);
ALTER TABLE TB_DIM_ESTADIO
MODIFY SK_ESTADIO DEFAULT SQ_SK_ESTADIO.NEXTVAL;



CREATE SEQUENCE SQ_SK_ESQUEMA;

CREATE TABLE TB_DIM_ESQUEMA_TATICO (
                sk_esquema NUMBER NOT NULL,
                descricao VARCHAR2(20) NOT NULL,
                CONSTRAINT DIM_ESQUEMA_TATICO_PK PRIMARY KEY (sk_esquema)
);
ALTER TABLE TB_DIM_ESQUEMA_TATICO 
MODIFY SK_ESQUEMA DEFAULT SQ_SK_ESQUEMA.NEXTVAL;


CREATE SEQUENCE SQ_SK_CLUBE;

CREATE TABLE TB_DIM_CLUBE (
                sk_clube NUMBER NOT NULL,
                cod_clube NUMBER NOT NULL,
                nome VARCHAR2(50) NOT NULL,
                escudo BLOB,
                cidade VARCHAR2(60) NOT NULL,
                estado VARCHAR2(60) NOT NULL,
                sigla_estado VARCHAR2(2) NOT NULL,
                regiao VARCHAR2(60) NOT NULL,
		versao NUMBER NOT NULL,
                data_inicio DATE NOT NULL,		
                data_fim DATE,		
                CONSTRAINT TB_DIM_CLUBE_PK PRIMARY KEY (sk_clube)
);
ALTER TABLE TB_DIM_CLUBE
MODIFY SK_CLUBE DEFAULT SQ_SK_CLUBE.NEXTVAL;


CREATE TABLE TB_DIM_TEMPO (
                PK_ANO_MES_DIA VARCHAR2(8) NOT NULL, -- 19740310
                DATA_DATE DATE NOT NULL, 
                DATA_STR VARCHAR2(10), -- 10/03/1974 

	        ANO VARCHAR2(4),  -- 1974

                MES_NUM VARCHAR2(2), -- 03 
	        MES_DESC VARCHAR2(10),  --  MARÇO 
		MES_ABREV VARCHAR2(3),  --  MAR     

                ANO_MES_NUM VARCHAR2(6),  -- 197403
                MES_ANO_NUM VARCHAR2(7),  -- 03/1974
	        MES_ANO_COMPLETO_DESC VARCHAR2(15), -- MARÇO/1974
                MES_ANO_ABREV_DESC VARCHAR2(8),  -- MAR/1974

		DIA VARCHAR2(2),  -- 10 (OU 05 OU 09...)
		DIA_SEMANA_NUM VARCHAR2(1),  -- 1=DOMINGO, ......7=SÁBADO 	        
		DIA_SEMANA_DESC VARCHAR2(15),  -- DOMINGO
                FLAG_FINAL_SEMANA CHAR(1), -- S OU N

		CONSTRAINT DIM_TEMPO_PK PRIMARY KEY (PK_ANO_MES_DIA)
);

CREATE SEQUENCE SQ_SK_CAMPEONATO;

CREATE TABLE TB_DIM_CAMPEONATO (
                sk_campeonato NUMBER NOT NULL,
                cod_campeonato VARCHAR2(7) NOT NULL,
                nome VARCHAR2(60) NOT NULL,
                ano_edicao VARCHAR2(4) NOT NULL,
                CONSTRAINT TB_DIM_CAMPEONATO_PK PRIMARY KEY (sk_campeonato)
);
ALTER TABLE TB_DIM_CAMPEONATO 
MODIFY SK_CAMPEONATO DEFAULT SQ_SK_CAMPEONATO.NEXTVAL;


CREATE TABLE TB_FATO_JOGO (
                id_jogo NUMBER NOT NULL,
                sk_campeonato NUMBER NOT NULL,
                sk_clube_mandante NUMBER NOT NULL,
                sk_clube_visitante NUMBER NOT NULL,
                sk_estadio NUMBER NOT NULL,
                sk_esquema_mandante NUMBER NOT NULL,
                sk_esquema_visitante NUMBER NOT NULL,
                fk_ano_mes_dia VARCHAR2(8) NOT NULL,
                rodada NUMBER NOT NULL,
                hora VARCHAR2(5) NOT NULL,
                turno_dia VARCHAR2(10) NOT NULL,
                gols_mandante NUMBER NOT NULL,
                gols_visitante NUMBER NOT NULL,
                vitorias_mandante NUMBER NOT NULL,
                vitorias_visitante NUMBER NOT NULL,
                derrotas_mandante NUMBER NOT NULL,
                derrotas_visitante NUMBER NOT NULL,
                empates_mandante NUMBER NOT NULL,
                empates_visitante NUMBER NOT NULL,
                pontos_mandante NUMBER NOT NULL,
                pontos_visitante NUMBER NOT NULL,
                cartoes_amarelos_mandante NUMBER NOT NULL,
                cartoes_amarelos_visitante NUMBER NOT NULL,
                cartoes_vermelhos_mandante NUMBER NOT NULL,
                cartoes_vermelhos_visitante NUMBER NOT NULL,
                CONSTRAINT TB_FATO_JOGO_PK PRIMARY KEY (id_jogo)
);


ALTER TABLE TB_FATO_JOGO ADD CONSTRAINT ESTADIO_JOGO_FK
FOREIGN KEY (sk_estadio)
REFERENCES TB_DIM_ESTADIO (sk_estadio)
NOT DEFERRABLE;

ALTER TABLE TB_FATO_JOGO ADD CONSTRAINT ESQUEMA_JOGO_FK
FOREIGN KEY (sk_esquema_mandante)
REFERENCES TB_DIM_ESQUEMA_TATICO (sk_esquema)
NOT DEFERRABLE;

ALTER TABLE TB_FATO_JOGO ADD CONSTRAINT ESQUEMA_JOGO_FK1
FOREIGN KEY (sk_esquema_visitante)
REFERENCES TB_DIM_ESQUEMA_TATICO (sk_esquema)
NOT DEFERRABLE;

ALTER TABLE TB_FATO_JOGO ADD CONSTRAINT CLUBE_JOGO_FK
FOREIGN KEY (sk_clube_mandante)
REFERENCES TB_DIM_CLUBE (sk_clube)
NOT DEFERRABLE;

ALTER TABLE TB_FATO_JOGO ADD CONSTRAINT CLUBE_JOGO_FK1
FOREIGN KEY (sk_clube_visitante)
REFERENCES TB_DIM_CLUBE (sk_clube)
NOT DEFERRABLE;

ALTER TABLE TB_FATO_JOGO ADD CONSTRAINT TEMPO_JOGO_FK
FOREIGN KEY (fk_ano_mes_dia)
REFERENCES TB_DIM_TEMPO (pk_ano_mes_dia)
NOT DEFERRABLE;

ALTER TABLE TB_FATO_JOGO ADD CONSTRAINT CAMPEONATO_JOGO_FK
FOREIGN KEY (sk_campeonato)
REFERENCES TB_DIM_CAMPEONATO (sk_campeonato)
NOT DEFERRABLE;
