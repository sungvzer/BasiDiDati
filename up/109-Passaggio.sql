CREATE TABLE Passaggio (
    settore_sensore NUMBER,
    data_ora TIMESTAMP,
    numero_auto NUMBER,
    sessione_id NUMBER NOT NULL,
    PRIMARY KEY (settore_sensore, data_ora)
);

ALTER TABLE Passaggio ADD FOREIGN KEY (numero_auto) REFERENCES Auto (numero);
ALTER TABLE Passaggio ADD FOREIGN KEY (sessione_id) REFERENCES Sessione (id);
ALTER TABLE Passaggio ADD FOREIGN KEY (settore_sensore) REFERENCES Sensore (settore);
