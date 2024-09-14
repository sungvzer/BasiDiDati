CREATE
OR REPLACE TRIGGER Sessioni_Contemporanee BEFORE
INSERT
    ON Sessione FOR EACH ROW
DECLARE
numero_sessioni INTEGER;

BEGIN
SELECT
    COUNT(*) INTO numero_sessioni
FROM
    Sessione
WHERE
    (
        (
            data_ora BETWEEN :NEW.data_ora AND :NEW.data_ora + :NEW.durata_min / (24 * 60)
        )
        OR (
            :NEW.data_ora BETWEEN data_ora AND data_ora + durata_min / (24 * 60)
        )
    );

IF numero_sessioni > 0 THEN RAISE_APPLICATION_ERROR (-20001, 'Sessioni sovrapposte');

END IF;

END;
