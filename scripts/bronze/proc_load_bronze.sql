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
    RAISE NOTICE 'Starting Bronze Layer Load';
    RAISE NOTICE 'Batch Start Time : %', batch_start_time;
    RAISE NOTICE '====================================================';

    --------------------------------------------------------------------
    -- CRM Customer Information
    --------------------------------------------------------------------
    RAISE NOTICE 'Loading CRM Customer Information...';

    table_start_time := clock_timestamp();

    TRUNCATE TABLE bronze.crm_cust_info;

    COPY bronze.crm_cust_info
    FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    DELIMITER ','
    CSV HEADER;

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

    TRUNCATE TABLE bronze.crm_prd_info;

    COPY bronze.crm_prd_info
    FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    DELIMITER ','
    CSV HEADER;

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

    TRUNCATE TABLE bronze.crm_sales_details;

    COPY bronze.crm_sales_details
    FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    DELIMITER ','
    CSV HEADER;

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

    TRUNCATE TABLE bronze.erp_cust_az12;

    COPY bronze.erp_cust_az12
    FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    DELIMITER ','
    CSV HEADER;

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

    TRUNCATE TABLE bronze.erp_loc_a101;

    COPY bronze.erp_loc_a101
    FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    DELIMITER ','
    CSV HEADER;

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

    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    COPY bronze.erp_px_cat_g1v2
    FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    DELIMITER ','
    CSV HEADER;

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
    RAISE NOTICE 'Bronze Layer Load Completed Successfully';
    RAISE NOTICE 'Batch Start Time : %', batch_start_time;
    RAISE NOTICE 'Batch End Time   : %', batch_end_time;
    RAISE NOTICE 'Total Duration   : %', batch_end_time - batch_start_time;
    RAISE NOTICE '====================================================';

EXCEPTION
    WHEN OTHERS THEN
        batch_end_time := clock_timestamp();

        RAISE NOTICE '====================================================';
        RAISE NOTICE 'Bronze Layer Load Failed!';
        RAISE NOTICE 'Failure Time   : %', batch_end_time;
        RAISE NOTICE 'Elapsed Time   : %', batch_end_time - batch_start_time;
        RAISE NOTICE 'SQLSTATE       : %', SQLSTATE;
        RAISE NOTICE 'Error Message  : %', SQLERRM;
        RAISE NOTICE '====================================================';

        RAISE;
END;
