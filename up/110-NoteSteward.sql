CREATE TABLE NoteSteward (
    codice_steward varchar(100),
    data_ora date,
    contenuto varchar(4000),
    sessione_id NUMBER,
    numero_auto NUMBER,
    PRIMARY KEY (codice_steward, data_ora)
);

