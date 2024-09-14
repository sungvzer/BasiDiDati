CREATE
OR REPLACE TRIGGER Iscrizioni_48_Ore BEFORE
INSERT
    ON Iscrizione FOR EACH ROW
DECLARE
ora_sessione DATE;

BEGIN
SELECT
    Sessione.data_ora INTO ora_sessione
FROM
    Sessione
WHERE
    :NEW.id_sessione = Sessione.id;

IF ora_sessione < SYSDATE + 2 THEN RAISE_APPLICATION_ERROR (
    -20002,
    'Iscrizione non possibile: mancano meno di 48 ore alla sessione, o l''orario della sessione è già passato.'
);

END IF;

END;
