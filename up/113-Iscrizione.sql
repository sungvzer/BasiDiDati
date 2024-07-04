CREATE TABLE Iscrizione (
    id_pilota NUMBER NOT NULL,
    numero_auto NUMBER NOT NULL,
    id_sessione NUMBER NOT NULL,
    nome_squadra VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_pilota, numero_auto, id_sessione, nome_squadra)
);

ALTER TABLE Iscrizione ADD FOREIGN KEY (id_pilota) REFERENCES Pilota (id);
ALTER TABLE Iscrizione ADD FOREIGN KEY (numero_auto) REFERENCES Auto (numero);
ALTER TABLE Iscrizione ADD FOREIGN KEY (id_sessione) REFERENCES Sessione (id);
ALTER TABLE Iscrizione ADD FOREIGN KEY (nome_squadra) REFERENCES Squadra (nome);
