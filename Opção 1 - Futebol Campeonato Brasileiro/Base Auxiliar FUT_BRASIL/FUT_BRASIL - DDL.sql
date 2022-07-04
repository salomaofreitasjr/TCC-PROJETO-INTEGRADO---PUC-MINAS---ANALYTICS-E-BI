--------------------------------------------------------
--  Arquivo criado - Domingo-Junho-26-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence SEQ_COD_CLUBE
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_COD_CLUBE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 221 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_COD_ESTADIO
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_COD_ESTADIO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 221 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Table TB_CIDADE
--------------------------------------------------------

  CREATE TABLE "TB_CIDADE" 
   (	"COD_CIDADE" NUMBER, 
	"NOME" VARCHAR2(60) COLLATE "USING_NLS_COMP", 
	"COD_ESTADO" NUMBER
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TB_CLUBE
--------------------------------------------------------

  CREATE TABLE "TB_CLUBE" 
   (	"COD_CLUBE" NUMBER, 
	"NOME" VARCHAR2(50) COLLATE "USING_NLS_COMP", 
	"ESCUDO" BLOB, 
	"COD_CIDADE" NUMBER
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TB_ESTADIO
--------------------------------------------------------

  CREATE TABLE "TB_ESTADIO" 
   (	"COD_ESTADIO" NUMBER, 
	"NOME" VARCHAR2(100) COLLATE "USING_NLS_COMP", 
	"CAPACIDADE" NUMBER, 
	"FOTO" BLOB, 
	"COD_CIDADE" NUMBER
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TB_ESTADO
--------------------------------------------------------

  CREATE TABLE "TB_ESTADO" 
   (	"COD_ESTADO" NUMBER, 
	"NOME" VARCHAR2(60) COLLATE "USING_NLS_COMP", 
	"SIGLA" VARCHAR2(2) COLLATE "USING_NLS_COMP", 
	"COD_REGIAO" NUMBER
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TB_REGIAO
--------------------------------------------------------

  CREATE TABLE "TB_REGIAO" 
   (	"COD_REGIAO" NUMBER, 
	"NOME" VARCHAR2(60) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TB_STG_CORRESPONDENCIA_CLUBE
--------------------------------------------------------

  CREATE TABLE "TB_STG_CORRESPONDENCIA_CLUBE" 
   (	"NOME_SUJO" VARCHAR2(50) COLLATE "USING_NLS_COMP", 
	"COD_CLUBE_CORRESPONDENTE" NUMBER
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TB_STG_CORRESPONDENCIA_ESTADIO
--------------------------------------------------------

  CREATE TABLE "TB_STG_CORRESPONDENCIA_ESTADIO" 
   (	"NOME_SUJO" VARCHAR2(100) COLLATE "USING_NLS_COMP", 
	"NOME_LIMPO" VARCHAR2(100) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TB_STG_CORRESPONDENCIA_ESTADIO_2
--------------------------------------------------------

  CREATE TABLE "TB_STG_CORRESPONDENCIA_ESTADIO_2" 
   (	"NOME_SUJO" VARCHAR2(100) COLLATE "USING_NLS_COMP", 
	"COD_ESTADIO_CORRESPONDENTE" NUMBER
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TMP_CAMPEONATO_BRASILEIRO_FULL
--------------------------------------------------------

  CREATE TABLE "TMP_CAMPEONATO_BRASILEIRO_FULL" 
   (	"ID" NUMBER(38,0), 
	"RODADA" NUMBER(38,0), 
	"DATA" TIMESTAMP (6), 
	"HORA" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"DIA" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"MANDANTE" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"VISITANTE" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"FORMACAO_MANDANTE" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"FORMACAO_VISITANTE" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"TECNICO_MANDANTE" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"TECNICO_VISITANTE" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"VENCEDOR" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"ARENA" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"MANDANTE_PLACAR" NUMBER(38,0), 
	"VISITANTE_PLACAR" NUMBER(38,0), 
	"MANDANTE_ESTADO" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"VISITANTE_ESTADO" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"ESTADO_VENCEDOR" VARCHAR2(4000) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TMP_ESTADOS
--------------------------------------------------------

  CREATE TABLE "TMP_ESTADOS" 
   (	"ID" NUMBER(38,0), 
	"CODIGOUF" NUMBER(38,0), 
	"NOME" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"UF" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"REGIAO" NUMBER(38,0)
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TMP_MUNICIPIOS
--------------------------------------------------------

  CREATE TABLE "TMP_MUNICIPIOS" 
   (	"ID" NUMBER(38,0), 
	"CODIGO" NUMBER(38,0), 
	"NOME" VARCHAR2(4000) COLLATE "USING_NLS_COMP", 
	"UF" VARCHAR2(4000) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Table TMP_REGIOES
--------------------------------------------------------

  CREATE TABLE "TMP_REGIOES" 
   (	"ID" NUMBER(38,0), 
	"NOME" VARCHAR2(4000) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP" ;
--------------------------------------------------------
--  DDL for Index TB_ESTADIO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TB_ESTADIO_PK" ON "TB_ESTADIO" ("COD_ESTADIO") 
  ;
--------------------------------------------------------
--  DDL for Index TB_CIDADE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TB_CIDADE_PK" ON "TB_CIDADE" ("COD_CIDADE") 
  ;
--------------------------------------------------------
--  DDL for Index TB_CLUBE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TB_CLUBE_PK" ON "TB_CLUBE" ("COD_CLUBE") 
  ;
--------------------------------------------------------
--  DDL for Index TB_REGIAO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TB_REGIAO_PK" ON "TB_REGIAO" ("COD_REGIAO") 
  ;
--------------------------------------------------------
--  DDL for Index TB_ESTADO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TB_ESTADO_PK" ON "TB_ESTADO" ("COD_ESTADO") 
  ;
--------------------------------------------------------
--  Constraints for Table TB_CIDADE
--------------------------------------------------------

  ALTER TABLE "TB_CIDADE" MODIFY ("COD_CIDADE" NOT NULL ENABLE);
  ALTER TABLE "TB_CIDADE" MODIFY ("NOME" NOT NULL ENABLE);
  ALTER TABLE "TB_CIDADE" MODIFY ("COD_ESTADO" NOT NULL ENABLE);
  ALTER TABLE "TB_CIDADE" ADD CONSTRAINT "TB_CIDADE_PK" PRIMARY KEY ("COD_CIDADE")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table TB_ESTADO
--------------------------------------------------------

  ALTER TABLE "TB_ESTADO" MODIFY ("COD_ESTADO" NOT NULL ENABLE);
  ALTER TABLE "TB_ESTADO" MODIFY ("NOME" NOT NULL ENABLE);
  ALTER TABLE "TB_ESTADO" MODIFY ("SIGLA" NOT NULL ENABLE);
  ALTER TABLE "TB_ESTADO" MODIFY ("COD_REGIAO" NOT NULL ENABLE);
  ALTER TABLE "TB_ESTADO" ADD CONSTRAINT "TB_ESTADO_PK" PRIMARY KEY ("COD_ESTADO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table TB_REGIAO
--------------------------------------------------------

  ALTER TABLE "TB_REGIAO" MODIFY ("COD_REGIAO" NOT NULL ENABLE);
  ALTER TABLE "TB_REGIAO" MODIFY ("NOME" NOT NULL ENABLE);
  ALTER TABLE "TB_REGIAO" ADD CONSTRAINT "TB_REGIAO_PK" PRIMARY KEY ("COD_REGIAO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table TB_CLUBE
--------------------------------------------------------

  ALTER TABLE "TB_CLUBE" MODIFY ("COD_CLUBE" NOT NULL ENABLE);
  ALTER TABLE "TB_CLUBE" MODIFY ("NOME" NOT NULL ENABLE);
  ALTER TABLE "TB_CLUBE" ADD CONSTRAINT "TB_CLUBE_PK" PRIMARY KEY ("COD_CLUBE")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table TB_ESTADIO
--------------------------------------------------------

  ALTER TABLE "TB_ESTADIO" MODIFY ("COD_ESTADIO" NOT NULL ENABLE);
  ALTER TABLE "TB_ESTADIO" MODIFY ("NOME" NOT NULL ENABLE);
  ALTER TABLE "TB_ESTADIO" ADD CONSTRAINT "TB_ESTADIO_PK" PRIMARY KEY ("COD_ESTADIO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TB_CIDADE
--------------------------------------------------------

  ALTER TABLE "TB_CIDADE" ADD CONSTRAINT "TB_ESTADO_TB_CIDADE_FK" FOREIGN KEY ("COD_ESTADO")
	  REFERENCES "TB_ESTADO" ("COD_ESTADO") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TB_CLUBE
--------------------------------------------------------

  ALTER TABLE "TB_CLUBE" ADD CONSTRAINT "TB_CIDADE_TB_CLUBE_FK" FOREIGN KEY ("COD_CIDADE")
	  REFERENCES "TB_CIDADE" ("COD_CIDADE") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TB_ESTADIO
--------------------------------------------------------

  ALTER TABLE "TB_ESTADIO" ADD CONSTRAINT "TB_CIDADE_TB_ESTADIO_FK" FOREIGN KEY ("COD_CIDADE")
	  REFERENCES "TB_CIDADE" ("COD_CIDADE") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TB_ESTADO
--------------------------------------------------------

  ALTER TABLE "TB_ESTADO" ADD CONSTRAINT "TB_REGIAO_TB_ESTADO_FK" FOREIGN KEY ("COD_REGIAO")
	  REFERENCES "TB_REGIAO" ("COD_REGIAO") ENABLE;
