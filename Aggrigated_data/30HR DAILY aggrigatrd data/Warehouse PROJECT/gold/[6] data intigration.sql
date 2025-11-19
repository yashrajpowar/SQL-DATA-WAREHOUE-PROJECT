

SELECT DISTINCT
	ci.cst_gndr,
	ca.GEN,
	CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr -- crm is master for gender info
	ELSE COALESCE(ca.GEN, 'N/A')
	END new_gen
FROM silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON		ci.cst_key = ca.CID
LEFT JOIN Silver.erp_loc_a101 la
ON		ci.cst_key = la.CID
ORDER BY 1,2