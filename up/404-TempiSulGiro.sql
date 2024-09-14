CREATE OR REPLACE FUNCTION TEMPI_SUL_GIRO(
    I_NUMERO_AUTO IN NUMBER,
    I_SESSIONE_ID IN NUMBER
) RETURN SYS_REFCURSOR IS
    C_TEMPI SYS_REFCURSOR;
BEGIN
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
