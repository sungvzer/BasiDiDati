CREATE OR REPLACE TRIGGER Passaggio_Durante_Sessione
BEFORE
INSERT ON Passaggio
FOR EACH ROW DECLARE data_ora DATE; durata NUMBER; BEGIN
SELECT Data_Ora,
       Durata_Min INTO data_ora,
                       durata
FROM Sessione
WHERE Sessione.ID = :NEW.Sessione_ID; IF :NEW.Data_Ora < data_ora
  OR :NEW.Data_Ora > data_ora + durata/1440 THEN RAISE_APPLICATION_ERROR (-20000, 'Il passaggio non è durante la sessione'); END IF; END;
