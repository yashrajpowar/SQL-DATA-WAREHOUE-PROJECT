
--###### Cleaning & loading the Bronze.crm_cust_info ########--


-- check for duplicates and NULL in primary key
--expectation = no result

SELECT 
cst_id,
COUNT(*)
FROM Bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id = NULL


-- check fro unwanted spaces
-- expectation = no results
SELECT 
cst_lastname
FROM Bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname) --If the original value is not equal to the same value after trimming, it means there are spaces!
	

-- Data standerdization and consistency
SELECT DISTINCT
--cst_gndr,
cst_marital_status
FROM Bronze.crm_cust_info


SELECT *
FROM Silver.crm_cust_info


---------------------------------------------------------------------------------------------------------------------------------------------------
--###### Cleaning & loading the Bronze.crm_prd_info########--

-- check for duplicates and NULL in primary key
--expectation = no result

SELECT 
prd_id,
COUNT(*)
FROM Bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id = NULL

-- check fro unwanted spaces
-- expectation = no results

SELECT 
prd_nm
FROM Bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm) --If the original value is not equal to the same value after trimming, it means there are spaces!

-- checks for NULLs and negative numbers
-- expectation = NO result

SELECT 
prd_cost
FROM Bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data standerdization and consistency
SELECT DISTINCT
prd_line
FROM Bronze.crm_prd_info

-- check for invalid date orders
SELECT
*
FROM Bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt -- start date must be smaller than end date -- end date = start date of the next record - 1


SELECT *
FROM Silver.crm_prd_info

----------------------------------------------------------------------------------------------------------------------------------
--###### Cleaning & loading the Bronze.crm_sales_detail########--

-- check for invalid date
SELECT
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM Bronze.crm_sales_detail
WHERE sls_order_dt <= 0
OR sls_order_dt < 0
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101

SELECT
NULLIF(sls_ship_dt,0) AS sls_ship_dt
FROM Bronze.crm_sales_detail
WHERE sls_ship_dt <= 0
OR sls_ship_dt < 0
OR LEN(sls_ship_dt) != 8 
OR sls_ship_dt > 20500101

SELECT
NULLIF(sls_due_dt,0) AS sls_due_dt
FROM Bronze.crm_sales_detail
WHERE sls_due_dt <= 0
OR sls_due_dt < 0
OR LEN(sls_due_dt) != 8 
OR sls_due_dt > 20500101

-- CHECK THE ORDER DATE MUST BE SMALLER SHIPPING DATE
SELECT
*
FROM Bronze.crm_sales_detail
WHERE sls_order_dt > sls_ship_dt

-- Check Data Consistency: Between Sales, Quantity, and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero, or negative.

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM Bronze.crm_sales_detail
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

/*Rules ( ASK THE DATA PROVIDER )
If Sales is negative, zero, or null, derive it using Quantity and Price.

If Price is zero or null, calculate it using Sales and Quantity.

If Price is negative, convert it to a positive value*/

SELECT DISTINCT
sls_sales AS OLD_sls_sales,
sls_quantity,
sls_price AS OLD_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
	 THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
	 END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <=0 
	 THEN sls_sales / NULLIF(sls_quantity,0)
	 ELSE sls_price
	 END AS sls_price

FROM Bronze.crm_sales_detail
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

SELECT *
FROM Silver.crm_sales_detail

----------------------------------------------------------------------------------------------------------------------------------
--###### Cleaning & loading the dbo.Bronze_erp_cust_az12########--


-- identify out_of_range dates
SELECT DISTINCT
BDATE
FROM Bronze_erp_cust_az12
WHERE BDATE < '1924-01-01' OR BDATE > GETDATE()

-- REMOVE THE FIRST 3 CHARACTER FROM (CID)
SELECT
CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
	 ELSE CID
	 END CID
FROM dbo.Bronze_erp_cust_az12

-- DATA STRANDARDIZATION AND CONSISTENCY
SELECT DISTINCT
GEN,
CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'N/A'
	 END AS GEN
FROM Bronze_erp_cust_az12

SELECT * FROM Silver.erp_cust_az12


----------------------------------------------------------------------------------------------------------------------------------
--###### Cleaning & loading the dbo.Bronze_erp_loc_a101########--

-- DATA standerdization and consistency
SELECT DISTINCT
CNTRY
FROM dbo.Bronze_erp_loc_a101
ORDER BY CNTRY

SELECT * FROM Silver.erp_loc_a101


----------------------------------------------------------------------------------------------------------------------------------
--###### Cleaning & loading the Bronze_erp_px_cat_g1v2########--

-- check for unwanted spaces
SELECT
CAT,
SUBCAT,
MAINTENANCE
FROM Bronze_erp_px_cat_g1v2
WHERE CAT != TRIM(CAT) OR SUBCAT != TRIM(SUBCAT) OR MAINTENANCE != TRIM(MAINTENANCE)

-- Data standerdization and consistency
SELECT DISTINCT
SUBCAT
FROM Bronze_erp_px_cat_g1v2;

SELECT DISTINCT
MAINTENANCE
FROM Bronze_erp_px_cat_g1v2;

SELECT DISTINCT
CAT
FROM Bronze_erp_px_cat_g1v2


SELECT * FROM Silver.erp_px_cat_g1v2
