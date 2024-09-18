CREATE OR REPLACE FUNCTION TEMPI_SUL_GIRO(
    I_NUMERO_AUTO IN NUMBER,
    I_SESSIONE_ID IN NUMBER
) RETURN SYS_REFCURSOR IS
    C_TEMPI            SYS_REFCURSOR;
    V_CONTA_AUTO       NUMBER;
    V_CONTA_ISCRIZIONI NUMBER;
    V_CONTA_SESSIONE   NUMBER;
BEGIN
    SELECT
        COUNT(*) INTO V_CONTA_AUTO
    FROM
        AUTO
    WHERE
        AUTO.NUMERO = I_NUMERO_AUTO;
    IF V_CONTA_AUTO = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Auto non trovata');
    END IF;

    SELECT
        COUNT(*) INTO V_CONTA_SESSIONE
    FROM
        SESSIONE
    WHERE
        SESSIONE.ID = I_SESSIONE_ID;
    IF V_CONTA_SESSIONE = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Sessione non trovata');
    END IF;

    SELECT
        COUNT(*) INTO V_CONTA_ISCRIZIONI
    FROM
        ISCRIZIONE
    WHERE
        ISCRIZIONE.ID_SESSIONE = I_SESSIONE_ID
        AND ISCRIZIONE.NUMERO_AUTO = I_NUMERO_AUTO;
    IF V_CONTA_ISCRIZIONI = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Auto non iscritta alla sessione');
    END IF;

    OPEN C_TEMPI FOR
        SELECT
            GIRO - 1 AS GIRO,
            TIMESTAMP_INIZIO,
            TIMESTAMP_FINE,
            (EXTRACT(DAY FROM DIFFERENZA) * 86400) + (EXTRACT(HOUR FROM DIFFERENZA) * 3600) + (EXTRACT(MINUTE FROM DIFFERENZA) * 60) + EXTRACT(SECOND FROM DIFFERENZA) AS TEMPO_SECONDI
        FROM
            (
 -- La funzione LAG restituisce il valore della colonna DATA_ORA della riga precedente rispetto all'ordine definito dalla clausola ORDER BY
                SELECT
                    LAG(DATA_ORA) OVER ( ORDER BY DATA_ORA)            AS TIMESTAMP_INIZIO,
                    DATA_ORA                                           AS TIMESTAMP_FINE,
                    ROW_NUMBER() OVER ( ORDER BY DATA_ORA)             AS GIRO,
                    DATA_ORA - LAG(DATA_ORA) OVER ( ORDER BY DATA_ORA) AS DIFFERENZA
                FROM
                    PASSAGGIO
                WHERE
                    NUMERO_AUTO = I_NUMERO_AUTO
                    AND SESSIONE_ID = I_SESSIONE_ID
                    AND SETTORE_SENSORE = 1
            )
        WHERE
            TIMESTAMP_INIZIO IS NOT NULL;
    RETURN C_TEMPI;
END;
 /* ESEMPIO DI CHIAMATA
DECLARE
    v_cursore SYS_REFCURSOR;
    v_giro NUMBER;
    v_timestamp_inizio TIMESTAMP;
    v_timestamp_fine TIMESTAMP;
    v_tempo_secondi NUMBER;
BEGIN
    -- Chiamata
    v_cursore := TEMPI_SUL_GIRO(I_NUMERO_AUTO => 101, I_SESSIONE_ID => 1);

    -- Loop di fetch dei dati
    LOOP
        FETCH v_cursore INTO v_giro, v_timestamp_inizio, v_timestamp_fine, v_tempo_secondi;
        EXIT WHEN v_cursore%NOTFOUND;

        -- Stampa a schermo
        DBMS_OUTPUT.PUT_LINE('Giro: ' || v_giro || ', Inizio: ' || v_timestamp_inizio || ', Fine: ' || v_timestamp_fine || ', Tempo (s): ' || v_tempo_secondi);
    END LOOP;

    -- Chiusura del cursore
    CLOSE v_cursore;
END;
*/
