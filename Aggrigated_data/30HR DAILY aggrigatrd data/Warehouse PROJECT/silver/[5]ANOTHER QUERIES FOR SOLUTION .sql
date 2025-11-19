
--###### Cleaning & loading the Bronze.crm_prd_info########--
-- START AND END DATE QUERY--
SELECT
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
DATEADD(DAY,-1,LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS prd_end_dt_TEST
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509' )

