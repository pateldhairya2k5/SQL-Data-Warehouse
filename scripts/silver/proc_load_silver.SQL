DO $$
DECLARE
    batch_start_time TIMESTAMP;
    batch_end_time   TIMESTAMP;
    table_start_time TIMESTAMP;
    table_end_time   TIMESTAMP;
BEGIN
    --------------------------------------------------------------------
    -- Batch Start
    --------------------------------------------------------------------
    batch_start_time := clock_timestamp();
    RAISE NOTICE '====================================================';
    RAISE NOTICE 'Starting Silver Layer Load';
    RAISE NOTICE 'Batch Start Time : %', batch_start_time;
    RAISE NOTICE '====================================================';

    --------------------------------------------------------------------
    -- CRM Customer Information
    --------------------------------------------------------------------
    RAISE NOTICE 'Loading CRM Customer Information...';
    table_start_time := clock_timestamp();

    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname)  AS cst_lastname,
        CASE
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            ELSE 'n/a'
        END AS cst_marital_status,
        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END AS cst_gndr,
        cst_create_date
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze.crm_cust_info
    ) AS t
    WHERE flag_last = 1;

    table_end_time := clock_timestamp();
    RAISE NOTICE 'CRM Customer Information Loaded Successfully.';
    RAISE NOTICE 'Start Time : %', table_start_time;
    RAISE NOTICE 'End Time   : %', table_end_time;
    RAISE NOTICE 'Duration   : %', table_end_time - table_start_time;
    RAISE NOTICE '----------------------------------------------------';

    --------------------------------------------------------------------
    -- CRM Product Information
    --------------------------------------------------------------------
    RAISE NOTICE 'Loading CRM Product Information...';
    table_start_time := clock_timestamp();

    DROP TABLE IF EXISTS silver.crm_prd_info;

    CREATE TABLE silver.crm_prd_info (
        prd_id          INT,
        cat_id          VARCHAR(50),
        prd_key         VARCHAR(50),
        prd_nm          VARCHAR(50),
        prd_cost        INT,
        prd_line        VARCHAR(50),
        prd_start_dt    DATE,
        prd_end_dt      DATE,
        dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
        SUBSTRING(prd_key, 7, LENGTH(prd_key))      AS prd_key,
        prd_nm,
        COALESCE(prd_cost, 0)                       AS prd_cost,
        CASE
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            ELSE 'n/a'
        END AS prd_line,
        CAST(prd_start_dt AS DATE) AS prd_start_dt,
        CAST(
            LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1
            AS DATE
        ) AS prd_end_dt
    FROM bronze.crm_prd_info;

    table_end_time := clock_timestamp();
    RAISE NOTICE 'CRM Product Information Loaded Successfully.';
    RAISE NOTICE 'Start Time : %', table_start_time;
    RAISE NOTICE 'End Time   : %', table_end_time;
    RAISE NOTICE 'Duration   : %', table_end_time - table_start_time;
    RAISE NOTICE '----------------------------------------------------';

    --------------------------------------------------------------------
    -- CRM Sales Details
    --------------------------------------------------------------------
    RAISE NOTICE 'Loading CRM Sales Details...';
    table_start_time := clock_timestamp();

    DROP TABLE IF EXISTS silver.crm_sales_details;

    CREATE TABLE silver.crm_sales_details (
        sls_ord_num     VARCHAR(50),
        sls_prd_key     VARCHAR(50),
        sls_cust_id     INT,
        sls_order_dt    DATE,
        sls_ship_dt     DATE,
        sls_due_dt      DATE,
        sls_sales       INT,
        sls_quantity    INT,
        sls_price       INT,
        dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE
            WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END AS sls_order_dt,
        CASE
            WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END AS sls_ship_dt,
        CASE
            WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END AS sls_due_dt,
        CASE
            WHEN sls_sales IS NULL
              OR sls_sales <= 0
              OR sls_sales != ABS(sls_price * sls_quantity)
            THEN ABS(sls_price * sls_quantity)
            ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE
            WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END AS sls_price
    FROM bronze.crm_sales_details;

    table_end_time := clock_timestamp();
    RAISE NOTICE 'CRM Sales Details Loaded Successfully.';
    RAISE NOTICE 'Start Time : %', table_start_time;
    RAISE NOTICE 'End Time   : %', table_end_time;
    RAISE NOTICE 'Duration   : %', table_end_time - table_start_time;
    RAISE NOTICE '----------------------------------------------------';

    --------------------------------------------------------------------
    -- ERP Customer Information
    --------------------------------------------------------------------
    RAISE NOTICE 'Loading ERP Customer Information...';
    table_start_time := clock_timestamp();

    TRUNCATE TABLE silver.erp_cust_az12;

    INSERT INTO silver.erp_cust_az12 (
        cid,
        bdate,
        gen
    )
    SELECT
        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
            ELSE cid
        END AS cid,
        CASE
            WHEN bdate > NOW() THEN NULL
            ELSE bdate
        END AS bdate,
        CASE
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')   THEN 'Male'
            ELSE 'n/a'
        END AS gen
    FROM bronze.erp_cust_az12;

    table_end_time := clock_timestamp();
    RAISE NOTICE 'ERP Customer Information Loaded Successfully.';
    RAISE NOTICE 'Start Time : %', table_start_time;
    RAISE NOTICE 'End Time   : %', table_end_time;
    RAISE NOTICE 'Duration   : %', table_end_time - table_start_time;
    RAISE NOTICE '----------------------------------------------------';

    --------------------------------------------------------------------
    -- ERP Location Information
    --------------------------------------------------------------------
    RAISE NOTICE 'Loading ERP Location Information...';
    table_start_time := clock_timestamp();

    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101 (
        cid,
        cntry
    )
    SELECT
        REPLACE(cid, '-', '') AS cid,
        CASE
            WHEN TRIM(cntry) = 'DE'              THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA')    THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END AS cntry
    FROM bronze.erp_loc_a101;

    table_end_time := clock_timestamp();
    RAISE NOTICE 'ERP Location Information Loaded Successfully.';
    RAISE NOTICE 'Start Time : %', table_start_time;
    RAISE NOTICE 'End Time   : %', table_end_time;
    RAISE NOTICE 'Duration   : %', table_end_time - table_start_time;
    RAISE NOTICE '----------------------------------------------------';

    --------------------------------------------------------------------
    -- ERP Product Category Information
    --------------------------------------------------------------------
    RAISE NOTICE 'Loading ERP Product Category Information...';
    table_start_time := clock_timestamp();

    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    INSERT INTO silver.erp_px_cat_g1v2 (
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_g1v2;

    table_end_time := clock_timestamp();
    RAISE NOTICE 'ERP Product Category Information Loaded Successfully.';
    RAISE NOTICE 'Start Time : %', table_start_time;
    RAISE NOTICE 'End Time   : %', table_end_time;
    RAISE NOTICE 'Duration   : %', table_end_time - table_start_time;
    RAISE NOTICE '----------------------------------------------------';

    --------------------------------------------------------------------
    -- Batch End
    --------------------------------------------------------------------
    batch_end_time := clock_timestamp();
    RAISE NOTICE '====================================================';
    RAISE NOTICE 'Silver Layer Load Completed Successfully';
    RAISE NOTICE 'Batch Start Time : %', batch_start_time;
    RAISE NOTICE 'Batch End Time   : %', batch_end_time;
    RAISE NOTICE 'Total Duration   : %', batch_end_time - batch_start_time;
    RAISE NOTICE '====================================================';

EXCEPTION
    WHEN OTHERS THEN
        batch_end_time := clock_timestamp();
        RAISE NOTICE '====================================================';
        RAISE NOTICE 'Silver Layer Load Failed!';
        RAISE NOTICE 'Failure Time  : %', batch_end_time;
        RAISE NOTICE 'Elapsed Time  : %', batch_end_time - batch_start_time;
        RAISE NOTICE 'SQLSTATE      : %', SQLSTATE;
        RAISE NOTICE 'Error Message : %', SQLERRM;
        RAISE NOTICE '====================================================';
        RAISE;
END;
$$;
