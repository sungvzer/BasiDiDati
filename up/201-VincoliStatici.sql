--	Una sessione può essere svolta solo di venerdì, sabato, e domenica
ALTER TABLE SESSIONE
    ADD CONSTRAINT CHK_GIORNO CHECK (
        MOD(TO_CHAR(DATA_ORA, 'J'), 7) + 1 IN (5, 6, 7)
    ) ENABLE;

-- L’IBAN di un organizzatore è unico ed obbligatorio.
ALTER TABLE ORGANIZZATORE
    ADD CONSTRAINT IBAN_UNICO UNIQUE (
        IBAN
    ) ENABLE;

-- Il numero di un’auto è unico ed è compreso tra 1 e 9999
ALTER TABLE AUTO
    ADD CONSTRAINT NUMERO_AUTO_RANGE CHECK (
        NUMERO BETWEEN 1 AND 9999
    ) ENABLE;

-- Il tipo di una sessione può essere “prove libere”, “qualifica”, “gara”.
ALTER TABLE SESSIONE
    ADD CONSTRAINT TIPO_SESSIONE CHECK (
        TIPO IN ('prove_libere', 'qualifica', 'gara')
    ) ENABLE;

-- L’email di un organizzatore deve contenere almeno una @.
ALTER TABLE ORGANIZZATORE
    ADD CONSTRAINT EMAIL_ORGANIZZATORE CHECK (
        EMAIL LIKE '%@%'
    ) ENABLE;

-- La durata di una sessione dev’essere un numero positivo.
ALTER TABLE SESSIONE
    ADD CONSTRAINT DURATA_SESSIONE CHECK (
        DURATA_MIN > 0
    ) ENABLE;

-- La data di fine di un campionato dev’essere successiva alla data di inizio
ALTER TABLE CAMPIONATO
    ADD CONSTRAINT DATA_FINE_SUCCESSIVA CHECK (
        DATA_FINE > DATA_INIZIO
    ) ENABLE;

-- Il CAP dell’organizzatore deve essere una stringa di 5 caratteri numerici
ALTER TABLE ORGANIZZATORE
    ADD CONSTRAINT CAP_ORGANIZZATORE CHECK (
        CAP LIKE '_____' AND CAP NOT LIKE '%[^0-9]%'
    ) ENABLE;

-- La potenza massima di un’auto deve essere un numero positivo
ALTER TABLE AUTO
    ADD CONSTRAINT POTENZA_AUTO CHECK (
        POTENZA_CV > 0
    ) ENABLE;

-- Il peso di un’auto deve essere un numero positivo
ALTER TABLE AUTO
    ADD CONSTRAINT PESO_AUTO CHECK (
        PESO_KG > 0
    ) ENABLE;

-- Il peso minimo di una categoria deve essere un numero positivo
ALTER TABLE CATEGORIA
    ADD CONSTRAINT PESO_CATEGORIA CHECK (
        PESO_MINIMO_KG > 0
    ) ENABLE;

-- La potenza massima di una categoria deve essere un numero positivo
ALTER TABLE CATEGORIA
    ADD CONSTRAINT POTENZA_CATEGORIA CHECK (
        POTENZA_MASSIMA_CV > 0
    ) ENABLE;
