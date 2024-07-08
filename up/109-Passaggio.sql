CREATE TABLE Passaggio (
    settore_sensore NUMBER,
    data_ora TIMESTAMP(4),
    numero_auto NUMBER,
    sessione_id NUMBER NOT NULL,
    PRIMARY KEY (settore_sensore, data_ora)
);
