/*
=============================================================
Database and Schema Initialization
=============================================================
Description:
    This script initializes a PostgreSQL database named 'DataWarehouse'.
    If a database with the same name already exists, it is removed, and a
    fresh database is created. It also creates three schemas
    'bronze', 'silver', and 'gold' to organize data across different
    stages of the ETL pipeline.

Important:
    Executing this script will permanently delete the existing
    'DataWarehouse' database along with all of its contents before
    creating a new one. Make sure any important data has been backed up
    before running this script.
*/

/* Connect to the default database, usually (postgres) */

/*Drop the database and forcefully disconnect any active users (PostgreSQL 13+) */
DROP DATABASE IF EXISTS datawarehouse;
CREATE DATABASE datawarehouse;

/* switch to the database just created */
\c DataWarehouse

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
