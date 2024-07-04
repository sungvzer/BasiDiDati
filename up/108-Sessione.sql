CREATE TABLE Sessione(
    id NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    tipo VARCHAR(20),
    durata_min NUMBER,
    data_ora DATE,
    nome_campionato VARCHAR(100),
    anno_campionato NUMBER
);

ALTER TABLE Sessione ADD FOREIGN KEY (nome_campionato, anno_campionato) REFERENCES Campionato (nome, anno); 
