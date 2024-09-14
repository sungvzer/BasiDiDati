CREATE OR REPLACE TRIGGER Sessione_Durante_Campionato
BEFORE
INSERT ON Sessione
FOR EACH ROW DECLARE data_inizio DATE; data_fine DATE; BEGIN
SELECT Data_Inizio,
       Data_Fine INTO data_inizio,
                      data_fine
FROM Campionato
WHERE Nome = :NEW.Nome_Campionato
  AND Anno = :NEW.Anno_Campionato; IF :NEW.Data_Ora < data_inizio
  OR :NEW.Data_Ora > data_fine THEN RAISE_APPLICATION_ERROR (-20000, 'La sessione non è durante il campionato'); END IF; END;
