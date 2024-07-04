CREATE TABLE NoteSteward (
    nome_steward VARCHAR(100),
    data_ora DATE,
    contenuto LONG,
    sessione_id NUMBER,
    numero_auto NUMBER,
    PRIMARY KEY (nome_steward, data_ora)
);

ALTER TABLE NoteSteward ADD FOREIGN KEY (sessione_id) REFERENCES Sessione (id);
ALTER TABLE NoteSteward ADD FOREIGN KEY (numero_auto) REFERENCES Auto (numero);
