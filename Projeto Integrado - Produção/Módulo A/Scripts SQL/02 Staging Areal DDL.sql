
CREATE TABLE TB_STG_REGIAO (
                cod_regiao NUMBER,
                nome VARCHAR2(60)
);


CREATE TABLE TB_STG_ESTADO (
                cod_estado NUMBER,
                nome VARCHAR2(60),
                sigla VARCHAR2(2),
                cod_regiao NUMBER
);


CREATE TABLE TB_STG_CIDADE (
                cod_cidade NUMBER,
                nome VARCHAR2(60),
                cod_estado NUMBER
);


CREATE TABLE TB_STG_ESTADIO (
                cod_estadio VARCHAR2(5),
                nome VARCHAR2(50),
                capacidade NUMBER,
                cod_cidade NUMBER
);


CREATE TABLE TB_STG_ESQUEMA_TATICO (
                descricao VARCHAR2(20)
);


CREATE TABLE TB_STG_CLUBE (
                cod_clube VARCHAR2(5),
                nome VARCHAR2(50),
                escudo BLOB,
                cod_cidade NUMBER
);


CREATE TABLE TB_STG_CARTOES (
                partida_id VARCHAR2(10),
                clube VARCHAR2(50),
                cartoes_amarelos VARCHAR2(3),
                cartoes_vermelhos VARCHAR2(3)
);


CREATE TABLE TB_STG_JOGO (
                id VARCHAR2(10),
		calc_cod_campeonato VARCHAR2(7),
                rodada VARCHAR2(2),
                data VARCHAR2(10),
                hora VARCHAR2(5),
                calc_turno_dia VARCHAR2(10),
                mandante VARCHAR2(50),
		calc_cod_mandante NUMBER,
                visitante VARCHAR2(50),
		calc_cod_visitante NUMBER,
                formacao_mandante VARCHAR2(20),
                formacao_visitante VARCHAR2(20),
                arena VARCHAR2(100),
		calc_cod_arena NUMBER,
                mandante_placar VARCHAR2(2),
                visitante_placar VARCHAR2(2),
                calc_vitorias_mandante NUMBER,
                calc_vitorias_visitante NUMBER,
                calc_derrotas_mandante NUMBER,
                calc_derrotas_visitante NUMBER,
                calc_empates_mandante NUMBER,
                calc_empates_visitante NUMBER,
                calc_pontos_mandante NUMBER,
                calc_pontos_visitante NUMBER,
                calc_cartoes_amarelos_mandante NUMBER,
                calc_cartoes_amarelos_visitante NUMBER,
                calc_cartoes_vermelhos_mandante NUMBER,
                calc_cartoes_vermelhos_visitante NUMBER
);


CREATE TABLE TB_STG_CAMPEONATO (
                torneio VARCHAR2(7),
                inicio VARCHAR2(10),
                fim VARCHAR2(10),
                calc_nome VARCHAR2(60),
                calc_ano_edicao VARCHAR2(4)
);
