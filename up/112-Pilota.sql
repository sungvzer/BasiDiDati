CREATE TABLE PILOTA (
    ID NUMBER GENERATED BY DEFAULT AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    NOME VARCHAR(100),
    COGNOME VARCHAR(100),
    DATA_DI_NASCITA DATE,
    NAZIONALITA VARCHAR(100)
);
