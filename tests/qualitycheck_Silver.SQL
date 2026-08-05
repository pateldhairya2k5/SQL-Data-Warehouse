/*
===============================================================================
Silver Layer – Data Quality Checks
===============================================================================
Purpose:
    Run a set of validation queries against the silver layer to verify
    data quality after the load process. The checks cover:

    • Null or duplicate primary keys
    • Unwanted leading/trailing spaces in string columns
    • Standardization and consistency of categorical values
    • Invalid or out-of-range dates
    • Logical consistency between related fields (e.g. Sales = Qty × Price)

Usage:
    Execute these checks after calling silver.load_silver().
    Any rows returned indicate issues that should be investigated
    and fixed in the transformation logic or source data.
===============================================================================
*/

-- ====================================================================
-- Checking silver.crm_cust_info
-- ====================================================================

-- Nulls or duplicates in primary key
-- Expectation: no rows
SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;

-- Unwanted spaces
-- Expectation: no rows
SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key <> TRIM(cst_key);

-- Data standardization & consistency
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;

SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;

-- ====================================================================
-- Checking silver.crm_prd_info
-- ====================================================================

-- Nulls or duplicates in primary key
-- Expectation: no rows
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;

-- Unwanted spaces
-- Expectation: no rows
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- Null or negative cost
-- Expectation: no rows
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0
    OR prd_cost IS NULL;

-- Data standardization & consistency
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

-- Invalid date order (end date before start date)
-- Expectation: no rows
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking silver.crm_sales_details
-- ====================================================================

-- Invalid dates in bronze source (still integer format)
-- Expectation: no rows
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LENGTH(sls_due_dt::TEXT) <> 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

-- Invalid date order (order date after ship/due date)
-- Expectation: no rows
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Sales consistency: Sales = Quantity × Price
-- Expectation: no rows
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales  <> sls_quantity * sls_price
   OR sls_sales  IS NULL
   OR sls_quantity IS NULL
   OR sls_price  IS NULL
   OR sls_sales  <= 0
   OR sls_quantity <= 0
   OR sls_price  <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking silver.erp_cust_az12
-- ====================================================================

-- Out-of-range birth dates
-- Expectation: birth dates between 1924-01-01 and today
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < DATE '1924-01-01'
   OR bdate > CURRENT_DATE;

-- Data standardization & consistency
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;

-- ====================================================================
-- Checking silver.erp_loc_a101
-- ====================================================================

-- Data standardization & consistency
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking silver.erp_px_cat_g1v2
-- ====================================================================

-- Unwanted spaces
-- Expectation: no rows
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat         <> TRIM(cat)
   OR subcat      <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);

-- Data standardization & consistency
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;
