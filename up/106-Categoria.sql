CREATE TABLE Categoria (
    ente_certificazione VARCHAR(100),
    nome VARCHAR(100),
    potenza_massima_cv NUMBER,
    peso_minimo_kg NUMBER,
    PRIMARY KEY (ente_certificazione, nome)
);
