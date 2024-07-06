ALTER TABLE Organizzazione_Campionato ADD FOREIGN KEY (p_iva_organizzatore) REFERENCES Organizzatore (p_iva);
ALTER TABLE Organizzazione_Campionato ADD FOREIGN KEY (nome_campionato, anno_campionato) REFERENCES Campionato (nome, anno);

ALTER TABLE Sponsor ADD FOREIGN KEY (nome_campionato, anno_campionato) REFERENCES Campionato (nome, anno);

ALTER TABLE Auto ADD FOREIGN KEY (nome_categoria,ente_categoria) REFERENCES Categoria (nome, ente_certificazione); 

ALTER TABLE Sessione ADD FOREIGN KEY (nome_campionato, anno_campionato) REFERENCES Campionato (nome, anno); 

ALTER TABLE Passaggio ADD FOREIGN KEY (numero_auto) REFERENCES Auto (numero);
ALTER TABLE Passaggio ADD FOREIGN KEY (sessione_id) REFERENCES Sessione (id);
ALTER TABLE Passaggio ADD FOREIGN KEY (settore_sensore) REFERENCES Sensore (settore);

ALTER TABLE NoteSteward ADD FOREIGN KEY (sessione_id) REFERENCES Sessione (id);
ALTER TABLE NoteSteward ADD FOREIGN KEY (numero_auto) REFERENCES Auto (numero);

ALTER TABLE Iscrizione ADD FOREIGN KEY (id_pilota) REFERENCES Pilota (id);
ALTER TABLE Iscrizione ADD FOREIGN KEY (numero_auto) REFERENCES Auto (numero);
ALTER TABLE Iscrizione ADD FOREIGN KEY (id_sessione) REFERENCES Sessione (id);
ALTER TABLE Iscrizione ADD FOREIGN KEY (nome_squadra) REFERENCES Squadra (nome);
CREATE UNIQUE INDEX pilota_sessione ON iscrizione (id_pilota, id_sessione);
