/*
=============================================================
DDL Script: Silver Layer
=============================================================
Description:
    This script creates the Silver schema and all source tables.
    It then loads the data from the Bronze layer into their respective tables.
=============================================================
*/

BEGIN

    CREATE SCHEMA IF NOT EXISTS silver;

    CREATE TABLE IF NOT EXISTS silver.crm_cust_info (
        cst_id              INTEGER,
        cst_key             VARCHAR(20),
        cst_firstname       VARCHAR(50),
        cst_lastname        VARCHAR(50),
        cst_marital_status  CHAR(1),
        cst_gndr            CHAR(1),
        cst_create_date     DATE,
		dwh_create_date     TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS silver.crm_prd_info (
        prd_id          INTEGER,
        prd_key         VARCHAR(20),
        prd_nm          VARCHAR(100),
        prd_cost        NUMERIC(10,2),
        prd_line        CHAR(1),
        prd_start_dt    DATE,
        prd_end_dt      DATE,
		dwh_create_date     TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS silver.crm_sales_details (
        sls_ord_num     VARCHAR(20),
        sls_prd_key     VARCHAR(50),
        sls_cust_id     INTEGER,
        sls_order_dt    INTEGER,
        sls_ship_dt     INTEGER,
        sls_due_dt      INTEGER,
        sls_sales       NUMERIC(10,2),
        sls_quantity    INTEGER,
        sls_price       NUMERIC(10,2),
		dwh_create_date     TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS silver.erp_cust_az12 (
        cid     VARCHAR(20),
        bdate   DATE,
        gen     VARCHAR(10),
		dwh_create_date     TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS silver.erp_loc_a101 (
        cid     VARCHAR(20),
        cntry   VARCHAR(100),
		dwh_create_date     TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS silver.erp_px_cat_g1v2 (
        id             VARCHAR(20),
        cat            VARCHAR(100),
        subcat         VARCHAR(100),
        maintenance    VARCHAR(10),
		dwh_create_date     TIMESTAMP DEFAULT NOW()
    );

END;

