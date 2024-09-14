CREATE TABLE SPONSOR (
    NOME_AZIENDA VARCHAR(100),
    DATA_INIZIO DATE,
    DATA_FINE DATE,
    IMPORTO NUMBER,
    NOME_CAMPIONATO VARCHAR(100),
    ANNO_CAMPIONATO NUMBER,
    PRIMARY KEY (NOME_AZIENDA, DATA_INIZIO)
);
