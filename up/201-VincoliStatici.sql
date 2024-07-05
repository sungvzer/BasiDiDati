--	Una sessione può essere svolta solo di venerdì, sabato, e domenica
ALTER TABLE Sessione ADD CONSTRAINT chk_giorno CHECK (MOD(TO_CHAR(DATA_ORA , 'J'), 7) + 1 IN (5, 6, 7));
