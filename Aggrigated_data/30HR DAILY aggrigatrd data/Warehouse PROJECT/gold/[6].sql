
--------------------------------------------------------------------------------------------
--########### CREATE DIMENTION CUSTOMER ###########--
--------------------------------------------------------------------------------------------
CREATE VIEW Gold.dim_customer AS 
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.CNTRY AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr -- crm is master for gender info -- we do this because we have the two gender info fron two tables
		 ELSE COALESCE(ca.GEN, 'N/A')
	END AS gender,
	ca.BDATE AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON		ci.cst_key = ca.CID
LEFT JOIN Silver.erp_loc_a101 la
ON		ci.cst_key = la.CID


--------------------------------------------------------------------------------------------
--########### CREATE DIMENTION PRODUCT ###########--
--------------------------------------------------------------------------------------------

CREATE VIEW Gold.dim_products AS 
SELECT
	ROW_NUMBER() OVER(ORDER BY prd_start_dt,prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.CAT AS category,
	pc.SUBCAT AS subcategory,
	pc.MAINTENANCE,
	pn.prd_cost AS cost,
	pn.prd_line AS produt_line,
	pn.prd_start_dt AS start_date
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_px_cat_g1v2 pc
ON		pn.cat_id = pc.ID
WHERE prd_end_dt IS NULL -- Filter out all historical data


--------------------------------------------------------------------------------------------
--########### CREATE DIMENTION PRODUCT ###########--
--------------------------------------------------------------------------------------------
-- we have remove the original keys and added surrogate keys

CREATE VIEW Gold.fact_sales as
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales,
	sd.sls_quantity AS qantity,
	sd.sls_price AS price
FROM Silver.crm_sales_detail sd -- now join the dimention table's surrogated key
LEFT JOIN Gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN Gold.dim_customer cu
ON sd.sls_cust_id = cu.customer_id