--	Una sessione può essere svolta solo di venerdì, sabato, e domenica
ALTER TABLE Sessione ADD CONSTRAINT chk_giorno CHECK (MOD(TO_CHAR(DATA_ORA , 'J'), 7) + 1 IN (5, 6, 7)) ENABLE;

-- L’IBAN di un organizzatore è unico ed obbligatorio.
ALTER TABLE Organizzatore ADD CONSTRAINT iban_unico UNIQUE (iban) ENABLE;

-- Il numero di un’auto è unico ed è compreso tra 1 e 9999
ALTER TABLE Auto ADD CONSTRAINT numero_auto_range CHECK (numero BETWEEN 1 AND 9999) ENABLE;

-- Il tipo di una sessione può essere “prove libere”, “qualifica”, “gara”.
ALTER TABLE Sessione ADD CONSTRAINT tipo_sessione CHECK (tipo IN ('prove_libere', 'qualifica', 'gara')) ENABLE;

-- L’email di un organizzatore deve contenere almeno una @.
ALTER TABLE Organizzatore ADD CONSTRAINT email_organizzatore CHECK (email LIKE '%@%') ENABLE;

-- La durata di una sessione dev’essere un numero positivo.
ALTER TABLE Sessione ADD CONSTRAINT durata_sessione CHECK (durata_min > 0) ENABLE;

-- La data di fine di un campionato dev’essere successiva alla data di inizio
ALTER TABLE Campionato ADD CONSTRAINT data_fine_successiva CHECK (data_fine > data_inizio) ENABLE;

-- Il CAP dell’organizzatore deve essere una stringa di 5 caratteri numerici
ALTER TABLE Organizzatore ADD CONSTRAINT cap_organizzatore CHECK (cap LIKE '_____' AND cap NOT LIKE '%[^0-9]%') ENABLE;

-- La potenza massima di un’auto deve essere un numero positivo
ALTER TABLE Auto ADD CONSTRAINT potenza_auto CHECK (potenza_cv > 0) ENABLE;

-- Il peso di un’auto deve essere un numero positivo
ALTER TABLE Auto ADD CONSTRAINT peso_auto CHECK (peso_kg > 0) ENABLE;

-- Il peso minimo di una categoria deve essere un numero positivo
ALTER TABLE Categoria ADD CONSTRAINT peso_categoria CHECK (peso_minimo_kg > 0) ENABLE;

-- La potenza massima di una categoria deve essere un numero positivo
ALTER TABLE Categoria ADD CONSTRAINT potenza_categoria CHECK (potenza_massima_cv > 0) ENABLE;
