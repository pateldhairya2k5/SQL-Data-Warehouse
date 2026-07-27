/*
=============================================================
DDL Script: Bronze Layer
=============================================================
Description:
    This script creates the Bronze schema and all source tables.
    It then loads the raw CSV files into their respective tables.
=============================================================
*/

-------------------------------------------------------------
-- Create Bronze Schema
-------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS bronze;

-------------------------------------------------------------
-- CRM Customer Information
-------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id              INTEGER,
    cst_key             VARCHAR(20),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  CHAR(1),
    cst_gndr            CHAR(1),
    cst_create_date     DATE
);

COPY bronze.crm_cust_info
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
DELIMITER ','
CSV HEADER;

-------------------------------------------------------------
-- CRM Product Information
-------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
    prd_id          INTEGER,
    prd_key         VARCHAR(20),
    prd_nm          VARCHAR(100),
    prd_cost        NUMERIC(10,2),
    prd_line        CHAR(1),
    prd_start_dt    DATE,
    prd_end_dt      DATE
);

COPY bronze.crm_prd_info
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
DELIMITER ','
CSV HEADER;

-------------------------------------------------------------
-- CRM Sales Details
-------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
    sls_ord_num     VARCHAR(20),
    sls_prd_key     VARCHAR(50),
    sls_cust_id     INTEGER,
    sls_order_dt    INTEGER,
    sls_ship_dt     INTEGER,
    sls_due_dt      INTEGER,
    sls_sales       NUMERIC(10,2),
    sls_quantity    INTEGER,
    sls_price       NUMERIC(10,2)
);

COPY bronze.crm_sales_details
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
DELIMITER ','
CSV HEADER;

-------------------------------------------------------------
-- ERP Customer Information
-------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    cid     VARCHAR(20),
    bdate   DATE,
    gen     VARCHAR(10)
);

COPY bronze.erp_cust_az12
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
DELIMITER ','
CSV HEADER;

-------------------------------------------------------------
-- ERP Location Information
-------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    cid     VARCHAR(20),
    cntry   VARCHAR(100)
);

COPY bronze.erp_loc_a101
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
DELIMITER ','
CSV HEADER;

-------------------------------------------------------------
-- ERP Product Category Information
-------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
    id             VARCHAR(20),
    cat            VARCHAR(100),
    subcat         VARCHAR(100),
    maintenance    VARCHAR(10)
);

COPY bronze.erp_px_cat_g1v2
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
DELIMITER ','
CSV HEADER;

