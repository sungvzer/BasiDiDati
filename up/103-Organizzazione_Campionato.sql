CREATE TABLE Organizzazione_Campionato (
  p_iva_organizzatore VARCHAR(11),
  nome_campionato VARCHAR(100),
  anno_campionato NUMBER,
  created_at timestamp,
  PRIMARY KEY (p_iva_organizzatore, nome_campionato, anno_campionato)
);
