--------------------------------------------------------
-- DATA MART - CASO IATA
-- Esquema: IATA
-- Tablas del Modelo Estrella
--------------------------------------------------------

--------------------------------------------------------
-- 1. DIMENSIONES
--------------------------------------------------------

CREATE TABLE "IATA"."DIM_FECHA"
(
    "ID_FECHA"   NUMBER(*,0)  NOT NULL,
    "FECHA"      DATE         NOT NULL,
    "MES"        NUMBER(*,0)  NOT NULL,
    "SEMESTRE"   NUMBER(*,0)  NOT NULL,
    "ANIO"       NUMBER(*,0)  NOT NULL,
    CONSTRAINT "DIM_FECHA_PK" PRIMARY KEY ("ID_FECHA") ENABLE
);

CREATE TABLE "IATA"."DIM_AEROLINEA"
(
    "ID_AEROLINEA"  NUMBER(*,0)    NOT NULL,
    "NOMBRE"        VARCHAR2(50)   NOT NULL,
    CONSTRAINT "DIM_AEROLINEA_PK" PRIMARY KEY ("ID_AEROLINEA") ENABLE
);

CREATE TABLE "IATA"."DIM_AVION"
(
    "ID_AVION"    NUMBER(*,0)   NOT NULL,
    "NOMBRE"      VARCHAR2(50)  NOT NULL,
    "MODELO"      VARCHAR2(50)  NOT NULL,
    "AEROLINEA"   VARCHAR2(50)  NOT NULL,
    CONSTRAINT "DIM_AVION_PK" PRIMARY KEY ("ID_AVION") ENABLE
);

CREATE TABLE "IATA"."DIM_CIUDAD"
(
    "ID_CIUDAD"  NUMBER(*,0)   NOT NULL,
    "NOMBRE"     VARCHAR2(50)  NOT NULL,
    CONSTRAINT "DIM_CIUDAD_PK" PRIMARY KEY ("ID_CIUDAD") ENABLE
);

--------------------------------------------------------
-- 2. TABLA DE HECHOS
--------------------------------------------------------

CREATE TABLE "IATA"."FACT_VUELOS"
(
    "ID_FACT"             NUMBER(*,0)  NOT NULL,
    "ID_FECHA"            NUMBER(*,0)  NOT NULL,
    "ID_AEROLINEA"        NUMBER(*,0)  NOT NULL,
    "ID_AVION"            NUMBER(*,0)  NOT NULL,
    "ID_CIUDAD_ORIGEN"    NUMBER(*,0)  NOT NULL,
    "ID_CIUDAD_DESTINO"   NUMBER(*,0)  NOT NULL,
    "TOTAL_VUELOS"        NUMBER(*,0)  DEFAULT 1 NOT NULL,
    "TOTAL_RECAUDADO"     NUMBER(*,0)  NOT NULL,

    CONSTRAINT "FACT_VUELOS_PK"
        PRIMARY KEY ("ID_FACT") ENABLE,

    CONSTRAINT "FV_FECHA_FK"
        FOREIGN KEY ("ID_FECHA")
        REFERENCES "IATA"."DIM_FECHA" ("ID_FECHA") ENABLE,

    CONSTRAINT "FV_AEROLINEA_FK"
        FOREIGN KEY ("ID_AEROLINEA")
        REFERENCES "IATA"."DIM_AEROLINEA" ("ID_AEROLINEA") ENABLE,

    CONSTRAINT "FV_AVION_FK"
        FOREIGN KEY ("ID_AVION")
        REFERENCES "IATA"."DIM_AVION" ("ID_AVION") ENABLE,

    CONSTRAINT "FV_CIUDAD_ORIGEN_FK"
        FOREIGN KEY ("ID_CIUDAD_ORIGEN")
        REFERENCES "IATA"."DIM_CIUDAD" ("ID_CIUDAD") ENABLE,

    CONSTRAINT "FV_CIUDAD_DESTINO_FK"
        FOREIGN KEY ("ID_CIUDAD_DESTINO")
        REFERENCES "IATA"."DIM_CIUDAD" ("ID_CIUDAD") ENABLE
);
