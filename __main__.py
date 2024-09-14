'''
    This script is used to execute SQL scripts in the UP and DOWN folders.
'''
import argparse
import os
import sys
import time
import logging
import oracledb


def execute_sql_file(connection, file_path: str):
    """
    Executes the SQL statements in the given file using the provided Oracle database connection.

    :param connection: A connection object to the Oracle database.
    :param file_path: The path to the SQL file.
    """
    logger = logging.getLogger(execute_sql_file.__name__)
    try:
        with open(file_path, 'r', encoding="utf-8") as file:
            sql_script = file.read()

        cursor = connection.cursor()

        if 'Dinamici' in file_path:
            cursor.execute(sql_script)
            logger.info("VINCOLI DINAMICI OK")
            return True

        # Split the SQL script into individual statements and execute each one
        for statement in sql_script.split(';'):
            if statement.strip():
                cursor.execute(statement.strip())

        connection.commit()  # Commit the transaction if all statements execute successfully
        logger.info("SQL script executed successfully.")
        return True

    except oracledb.Error as exception:
        logger.error(
            "An error occurred while executing the SQL script: %s", exception)
        return False

    finally:
        cursor.close()


def main():
    '''
        Main function to execute the SQL scripts in the UP and DOWN folders.
    '''
    connection_string = 'localhost/XEPDB1'
    system_username = 'SYS'
    system_password = 'dbpass'

    username = 'GrandPrixGrandstand'
    password = '23turns3sectors'

    logging.basicConfig(level=logging.INFO,
                        handlers=[
                            logging.FileHandler('log.log', 'w', 'utf-8'),
                            logging.StreamHandler(sys.stdout)
                        ])

    logger = logging.getLogger(__name__)
    logger.addHandler(logging.StreamHandler())

    parser = argparse.ArgumentParser(
        prog='Basi di Dati SQL',
    )
    parser.add_argument(
        '--down', help='Run the SQL scripts in the DOWN folder', action='store_true')

    args = parser.parse_args(sys.argv[1:])

    if False:  # pylint: disable=using-constant-test
        with oracledb.connect(
                user=system_username,
                password=system_password,
                dsn=connection_string,
                mode=oracledb.AUTH_MODE_SYSDBA
        ) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT sid, serial# FROM v$session WHERE username = :username", [
                username.upper()
            ])
            sessions = cursor.fetchall()
            if not sessions:
                print(f"No sessions found for user {username.upper()}")
            else:
                for sid, serial in sessions:
                    try:
                        # Esegui il comando per terminare la sessione
                        cursor.execute(f"ALTER SYSTEM KILL SESSION '{
                            sid},{serial}' IMMEDIATE")
                        print(f"Successfully killed session {
                            sid}, {serial} for user {username.upper()}")
                    except Exception as e:  # pylint: disable=broad-except
                        print(f"Failed to kill session {sid}, {
                            serial} for user {username.upper()}: {e}")

            cursor.execute(f"""
        DECLARE
            user_count INTEGER;
        BEGIN
            SELECT COUNT(*)
            INTO user_count
            FROM dba_users
            WHERE username = UPPER('{username}');

            IF user_count > 0 THEN
                EXECUTE IMMEDIATE 'DROP USER {username} CASCADE';
            END IF;
        END;
        """)

    # ensure that the user exists
    with oracledb.connect(
        user=system_username,
        password=system_password,
        dsn=connection_string,
        mode=oracledb.AUTH_MODE_SYSDBA
    ) as conn:
        cursor = conn.cursor()
        try:
            result = cursor.execute(
                f"SELECT COUNT(*) FROM all_users WHERE username = '{username.upper()}'").fetchone()
            if result[0] == 0:
                cursor.execute(
                    f'CREATE USER {username} IDENTIFIED BY "{password}"')
                cursor.execute(
                    f"GRANT ALL PRIVILEGES TO {username}")
            else:
                # Unlock the user account
                cursor.execute(
                    f"ALTER USER {username} ACCOUNT UNLOCK")

        except oracledb.Error as e:
            logger.error("Error creating user: %s", e)
            sys.exit(1)

        finally:
            cursor.close()

    if args.down:
        logger.info('==== DOWN ====')

        for filename in sorted(os.listdir('down'), reverse=True):
            if filename.startswith('000-'):
                continue
            if filename.endswith('.sql'):
                with oracledb.connect(user=username, password=password, dsn=connection_string) as conn:
                    logger.info('Executing down/%s', filename)
                    start_time = time.time()
                    execute_sql_file(conn, f'down/{filename}')
                    logger.info('Executed %s in %.2f seconds',
                                filename, time.time() - start_time)

    logger.info('==== MIGRATION TABLE ====')

    last_migration = None

    # if the migration table does not exist, create it
    with oracledb.connect(user=username, password=password, dsn=connection_string) as conn:
        cursor = conn.cursor()
        try:
            exists = cursor.execute(
                "SELECT COUNT(*) FROM all_tables WHERE table_name = 'MIGRATION'").fetchone()
            if exists[0] == 0:
                cursor.execute(
                    """
                        CREATE TABLE migration (filename VARCHAR2(255) PRIMARY KEY, executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL)
                        """)
            else:
                print(cursor.connection)
                last_migration = cursor.execute(
                    "SELECT filename FROM migration ORDER BY executed_at DESC").fetchone()
                last_migration = last_migration[0] if last_migration else None
        except oracledb.Error as e:
            logger.error("Error creating migration table: %s", e)
            sys.exit(1)
        finally:
            cursor.close()

    logger.info('==== UP ====')

    filenames = os.listdir('up')
    # filter out the migrations before the last one
    if last_migration:
        filenames = [
            filename for filename in filenames if filename > last_migration]
        logger.info('Skipping migrations before %s', last_migration)

    for filename in sorted(filenames):
        if filename.startswith('000-'):
            continue
        if filename.endswith('.sql'):
            with oracledb.connect(user=username,
                                  password=password,
                                  dsn=connection_string) as conn:
                logger.info('Executing up/%s', filename)
                start_time = time.time()
                if not execute_sql_file(conn, f'up/{filename}'):
                    logger.error('Failed to execute %s', filename)
                    sys.exit(1)
                else:
                    logger.info('Inserting into migration table')
                    conn.cursor().execute(
                        "INSERT INTO migration (filename) VALUES (:file_name)",
                        file_name=filename
                    )
                    conn.commit()
                logger.info('Executed %s in %.2f seconds',
                            filename, time.time() - start_time)


if __name__ == '__main__':
    main()
