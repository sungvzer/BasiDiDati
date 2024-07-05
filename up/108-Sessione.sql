CREATE TABLE Sessione(
    id NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    tipo VARCHAR(20),
    durata_min NUMBER,
    data_ora DATE,
    nome_campionato VARCHAR(100) NOT NULL,
    anno_campionato NUMBER NOT NULL
);
