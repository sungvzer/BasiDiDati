DECLARE
    JOB_DOESNT_EXIST EXCEPTION;
    PRAGMA EXCEPTION_INIT( JOB_DOESNT_EXIST, -27475 );
BEGIN
    DBMS_SCHEDULER.DROP_JOB (
        JOB_NAME => 'pulizia_passaggi'
    );
    DBMS_SCHEDULER.CREATE_JOB (
        JOB_NAME => 'pulizia_passaggi',
        JOB_TYPE => 'PLSQL_BLOCK',
        JOB_ACTION => 'BEGIN DELETE FROM PASSAGGIO WHERE DATA_ORA < SYSTIMESTAMP - INTERVAL ''15'' DAY; END;',
        START_DATE => SYSTIMESTAMP,
        REPEAT_INTERVAL => 'freq=daily; byhour=0; byminute=0; bysecond=0',
        ENABLED => TRUE,
        COMMENTS => 'Rimuove i passaggi più vecchi di 15 giorni'
    );
EXCEPTION
    WHEN JOB_DOESNT_EXIST THEN
        DBMS_SCHEDULER.CREATE_JOB (
            JOB_NAME => 'pulizia_passaggi',
            JOB_TYPE => 'PLSQL_BLOCK',
            JOB_ACTION => 'BEGIN DELETE FROM PASSAGGIO WHERE DATA_ORA < SYSTIMESTAMP - INTERVAL ''15'' DAY; END;',
            START_DATE => SYSTIMESTAMP,
            REPEAT_INTERVAL => 'freq=daily; byhour=0; byminute=0; bysecond=0',
            ENABLED => TRUE,
            COMMENTS => 'Rimuove i passaggi più vecchi di 15 giorni'
        );
END;
