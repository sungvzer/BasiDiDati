CREATE TABLE Auto (
    numero NUMBER PRIMARY KEY,
    marca VARCHAR(100),
    potenza_cv NUMBER,
    peso_kg NUMBER,
    modello VARCHAR(100),
    ente_categoria VARCHAR(100),
    nome_categoria VARCHAR(100)
);

ALTER TABLE Auto ADD FOREIGN KEY (nome_categoria,ente_categoria) REFERENCES Categoria (nome, ente_certificazione); 
