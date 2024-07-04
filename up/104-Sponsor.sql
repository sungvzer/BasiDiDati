CREATE TABLE Sponsor (
    nome_azienda VARCHAR(100),
    data_inizio DATE,
    data_fine DATE,
    importo NUMBER,
    nome_campionato VARCHAR(100),
    anno_campionato NUMBER,
    PRIMARY KEY (nome_azienda, data_inizio)
);
