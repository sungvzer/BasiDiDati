CREATE USER GRANDPRIXGRANDSTAND IDENTIFIED BY "23turns3sectors";

GRANT ALL PRIVILEGES TO GRANDPRIXGRANDSTAND;

-- ORGANIZZATORE
CREATE ROLE GPG_ORGANIZZATORE;

GRANT SELECT, INSERT, UPDATE ON ORGANIZZATORE TO GPG_ORGANIZZATORE;

GRANT SELECT, INSERT, UPDATE ON CAMPIONATO TO GPG_ORGANIZZATORE;

GRANT SELECT, INSERT, UPDATE ON ORGANIZZAZIONE_CAMPIONATO TO GPG_ORGANIZZATORE;

GRANT SELECT, INSERT, UPDATE ON SESSIONE TO GPG_ORGANIZZATORE;

GRANT SELECT, INSERT, UPDATE ON SPONSOR TO GPG_ORGANIZZATORE;

GRANT SELECT ON ISCRIZIONE TO GPG_ORGANIZZATORE;

-- STEWARD
CREATE ROLE GPG_STEWARD;

GRANT SELECT ON SESSIONE TO GPG_STEWARD;

GRANT SELECT ON AUTO TO GPG_STEWARD;

GRANT SELECT ON ISCRIZIONE TO GPG_STEWARD;

GRANT SELECT ON PILOTA TO GPG_STEWARD;

GRANT SELECT, INSERT, UPDATE ON NOTESTEWARD TO GPG_STEWARD;

GRANT SELECT, INSERT, UPDATE ON PENALITA TO GPG_STEWARD;

-- TEAM MANAGER
CREATE ROLE GPG_TEAM_MANAGER;

GRANT SELECT, INSERT, UPDATE ON SQUADRA TO GPG_TEAM_MANAGER;

GRANT SELECT, INSERT, UPDATE ON PILOTA TO GPG_TEAM_MANAGER;

GRANT SELECT ON SESSIONE TO GPG_TEAM_MANAGER;

GRANT SELECT ON CAMPIONATO TO GPG_TEAM_MANAGER;

GRANT SELECT, INSERT, UPDATE ON ISCRIZIONE TO GPG_TEAM_MANAGER;

-- CREAZIONE UTENTI
CREATE USER ORGANIZZATORE_USER IDENTIFIED BY OrganizzatiEFelici;

GRANT ORGANIZZATORE_ROLE TO ORGANIZZATORE_USER;

GRANT CONNECT TO ORGANIZZATORE_USER;

-- Creazione utente STEWARD_USER
CREATE USER STEWARD_USER IDENTIFIED BY LaSicurezzaPrimaDiTutto;

-- Assegnazione del ruolo STEWARD_ROLE all'utente STEWARD_USER
GRANT STEWARD_ROLE TO STEWARD_USER;

-- Permessi di connessione
GRANT CONNECT TO STEWARD_USER;

-- Creazione utente TEAM_MANAGER_USER
CREATE USER TEAM_MANAGER_USER IDENTIFIED BY LaSquadraVincente;

-- Assegnazione del ruolo TEAM_MANAGER_ROLE all'utente TEAM_MANAGER_USER
GRANT TEAM_MANAGER_ROLE TO TEAM_MANAGER_USER;

-- Permessi di connessione
GRANT CONNECT TO TEAM_MANAGER_USER;
