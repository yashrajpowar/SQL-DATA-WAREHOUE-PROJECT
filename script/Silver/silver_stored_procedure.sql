/*

Stored Procedure: Load Silver Layer (Bronze -> Silver)

Script Purpose:
This stored procedure performs the ETL (Extract, Transform, Load) process to
populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
- Truncates Silver tables.
- Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
None.

This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC Silver.load_silver;

*/




CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

	-- CLEANING AND LOADING THE DATA FROM Bronze TO THE Silver--



	----------------------------------------------------------------------------------------------------------
	--###### Cleaning & loading the Bronze.crm_cust_info ########--


	TRUNCATE TABLE Silver.crm_cust_info;
	INSERT INTO Silver.crm_cust_info(
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
		TRIM(cst_lastname) AS cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			 ELSE 'N/A'
			 END cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			 ELSE 'N/A'
			 END cst_gndr,
		cst_create_date
	FROM(
		SELECT 
		*,
		ROW_NUMBER() OVER ( PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
		FROM Bronze.crm_cust_info
		WHERE cst_id IS NOT NULL

	) t 
		WHERE flag_last = 1

	
	----------------------------------------------------------------------------------------------------------------------------------
	--###### Cleaning & loading the Bronze.crm_prd_info########--

	TRUNCATE TABLE Silver.crm_prd_info;
	INSERT INTO Silver.crm_prd_info(
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
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- to connect erp_px_cat
		SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, -- to connect sales info																	
		prd_nm,
		ISNULL(prd_cost,0) AS prd_cost,
		CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
			 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
			 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
			 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring' 
			 ELSE 'N/A'
			 END AS prd_line,
		prd_start_dt,
		DATEADD(DAY,-1,LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS prd_end_dt -- EDITED IN ANOTHER QUERY ([5]ANOTHER QUERIES FOR SOLUTION) 
	FROM Bronze.crm_prd_info
	/*WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN
	(SELECT DISTINCT id FROM Bronze_erp_px_cat_g1v2)  -- TOFIND ANY CATEGORY id THAT IS NOT AVAILABLE IN erp TABLE */


	----------------------------------------------------------------------------------------------------------------------------------
	--###### Cleaning & loading the Bronze.crm_sales_detail########--

	TRUNCATE TABLE Silver.crm_sales_detail;
	INSERT INTO Silver.crm_sales_detail(
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
	CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
		 END AS sls_order_dt,
	CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_ship_dt AS VARCHAR)AS DATE)
		 END AS sls_ship_dt,
	CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_due_dt AS VARCHAR)AS DATE)
		 END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
		 THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
		 END AS sls_sales,
		sls_quantity,
	CASE WHEN sls_price IS NULL OR sls_price <=0 
		 THEN sls_sales / NULLIF(sls_quantity,0)
		 ELSE sls_price
		 END AS sls_price
	FROM Bronze.crm_sales_detail


	----------------------------------------------------------------------------------------------------------------------------------
	--###### Cleaning & loading the dbo.Bronze_erp_cust_az12########--


	TRUNCATE TABLE Silver.erp_cust_az12;
	INSERT INTO Silver.erp_cust_az12 (
		CID,
		BDATE,
		GEN
	)
	SELECT
	CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID)) -- renove NAS prefex if present
		 ELSE CID
		 END CID,
	CASE WHEN BDATE > GETDATE() THEN NULL
		 ELSE BDATE
		 END AS BDATE, -- set future bdates to null
	CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
		 WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
		 ELSE 'N/A'
		 END AS GEN --normalize gender value handle unknown cases
	FROM dbo.Bronze_erp_cust_az12


	----------------------------------------------------------------------------------------------------------------------------------
	--###### Cleaning & loading the dbo.Bronze_erp_loc_a101########--


	TRUNCATE TABLE Silver.erp_loc_a101;
	INSERT INTO Silver.erp_loc_a101(
		CID,
		CNTRY
	)
	SELECT
	REPLACE(CID,'-','') CID, -- REMOED THE '-' SIGN WHICH IS NOT IN OTHER TABLES CID
	CASE WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
		 WHEN TRIM(CNTRY) IN ('US', 'USA' ) THEN 'United States'
		 WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'N/A'
		 ELSE TRIM(CNTRY)
		 END AS CNTRY 
	FROM dbo.Bronze_erp_loc_a101


	----------------------------------------------------------------------------------------------------------------------------------
	--###### Cleaning & loading the Bronze_erp_px_cat_g1v2########--

	TRUNCATE TABLE Silver.erp_px_cat_g1v2;
	INSERT INTO Silver.erp_px_cat_g1v2(
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE 
	)
	SELECT
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE
	FROM Bronze_erp_px_cat_g1v2
END
