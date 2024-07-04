'''
    This script is used to execute SQL scripts in the UP and DOWN folders.
'''
import argparse
import os
import sys
import time
import logging
import oracledb


SYSTEM_USERNAME = 'SYS'
CONNECTION_STRING = 'localhost/XEPDB1'
SYSTEM_PASSWORD = 'dbpass'

USERNAME = 'GrandPrixGrandstand'
PASSWORD = '23turns3sectors'


def execute_sql_file(connection, file_path):
    """
    Executes the SQL statements in the given file using the provided Oracle database connection.

    :param connection: A connection object to the Oracle database.
    :param file_path: The path to the SQL file.
    """
    try:
        with open(file_path, 'r', encoding="utf-8") as file:
            sql_script = file.read()

        cursor = connection.cursor()
        # Split the SQL script into individual statements and execute each one
        for statement in sql_script.split(';'):
            if statement.strip():
                cursor.execute(statement.strip())

        connection.commit()  # Commit the transaction if all statements execute successfully
        logging.info("SQL script executed successfully.")

    except oracledb.Error as exception:
        logging.error(
            "An error occurred while executing the SQL script: %s", exception)

    finally:
        cursor.close()


parser = argparse.ArgumentParser(
    prog='Basi di Dati SQL',
)
parser.add_argument(
    '--up', help='Run the SQL scripts in the UP folder', action='store_true')
parser.add_argument(
    '--down', help='Run the SQL scripts in the DOWN folder', action='store_true')

args = parser.parse_args(sys.argv[1:])

logging.basicConfig(filename='log.log', level=logging.INFO, filemode='w')


if False:  # pylint: disable=using-constant-test
    with oracledb.connect(
            user=SYSTEM_USERNAME,
            password=SYSTEM_PASSWORD,
            dsn=CONNECTION_STRING,
            mode=oracledb.AUTH_MODE_SYSDBA
    ) as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT sid, serial# FROM v$session WHERE username = :username", [
                       USERNAME.upper()
                       ])
        sessions = cursor.fetchall()
        if not sessions:
            print(f"No sessions found for user {USERNAME.upper()}")
        else:
            for sid, serial in sessions:
                try:
                    # Esegui il comando per terminare la sessione
                    cursor.execute(f"ALTER SYSTEM KILL SESSION '{
                                   sid},{serial}' IMMEDIATE")
                    print(f"Successfully killed session {
                          sid}, {serial} for user {USERNAME.upper()}")
                except Exception as e:  # pylint: disable=broad-except
                    print(f"Failed to kill session {sid}, {
                          serial} for user {USERNAME.upper()}: {e}")

        cursor.execute(f"""
    DECLARE
        user_count INTEGER;
    BEGIN
        SELECT COUNT(*)
        INTO user_count
        FROM dba_users
        WHERE username = UPPER('{USERNAME}');

        IF user_count > 0 THEN
            EXECUTE IMMEDIATE 'DROP USER {USERNAME} CASCADE';
        END IF;
    END;
    """)


# ensure that the user exists
with oracledb.connect(
    user=SYSTEM_USERNAME,
    password=SYSTEM_PASSWORD,
    dsn=CONNECTION_STRING,
    mode=oracledb.AUTH_MODE_SYSDBA
) as conn:
    try:
        result = conn.cursor().execute(
            f"SELECT COUNT(*) FROM all_users WHERE username = '{USERNAME.upper()}'").fetchone()
        if result[0] == 0:
            conn.cursor().execute(
                f'CREATE USER {USERNAME} IDENTIFIED BY "{PASSWORD}"')
            conn.cursor().execute(
                f"GRANT ALL PRIVILEGES TO {USERNAME}")
        else:
            # Unlock the user account
            conn.cursor().execute(
                f"ALTER USER {USERNAME} ACCOUNT UNLOCK")

    except oracledb.Error as e:
        logging.error("Error creating user: %s", e)
        sys.exit(1)

logging.info('==== DOWN ====')

for filename in sorted(os.listdir('down'), reverse=True):
    if filename.startswith('000-'):
        continue
    if filename.endswith('.sql'):
        with oracledb.connect(user=USERNAME, password=PASSWORD, dsn=CONNECTION_STRING) as conn:
            logging.info('Executing down/%s', filename)
            start_time = time.time()
            execute_sql_file(conn, f'down/{filename}')
            logging.info('Executed %s in %s seconds',
                         filename, time.time() - start_time)

logging.info('==== UP ====')

for filename in sorted(os.listdir('up')):
    if filename.startswith('000-'):
        continue
    if filename.endswith('.sql'):
        with oracledb.connect(user=USERNAME, password=PASSWORD, dsn=CONNECTION_STRING) as conn:
            logging.info('Executing up/%s', filename)
            start_time = time.time()
            execute_sql_file(conn, f'up/{filename}')
            logging.info('Executed %s in %s seconds',
                         filename, time.time() - start_time)
