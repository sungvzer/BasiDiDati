CREATE TABLE Organizzatore (
    p_iva VARCHAR(11) PRIMARY KEY,
    iban VARCHAR(34) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL,
    via VARCHAR(50) NOT NULL,
    citta VARCHAR(50) NOT NULL,
    cap VARCHAR(5) NOT NULL
);
