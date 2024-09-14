CREATE
OR REPLACE TRIGGER Max_5_Sponsor
BEFORE
INSERT ON Sponsor
FOR EACH ROW DECLARE contatore_sponsor NUMBER; BEGIN
SELECT COUNT (*) INTO contatore_sponsor
FROM Sponsor
WHERE Nome_Campionato = :NEW.Nome_Campionato
  AND Anno_Campionato = :NEW.Anno_Campionato; IF contatore_sponsor >= 5 THEN RAISE_APPLICATION_ERROR (-20000, 'Numero massimo di sponsor raggiunto'); END IF; END;
