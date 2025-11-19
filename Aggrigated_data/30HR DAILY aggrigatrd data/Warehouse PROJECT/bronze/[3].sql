/*

Stored Procedure: Load Bronze Layer (Source -> Bronze)

Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
- Truncates the bronze tables before loading data.
- Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:|
None.
This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC bronze.load_bronze;

*/



EXEC Bronze.load_bronze

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
    BEGIN TRY
		PRINT '===================================================================';
		PRINT ' LOADING Bronze LAYER';
		PRINT '===================================================================';

		PRINT '-------------------------------------------------------------------';
		PRINT ' LOADING crm TABLES';
		PRINT '-------------------------------------------------------------------';

		--############1
		TRUNCATE TABLE Bronze.crm_cust_info;
		BULK INSERT Bronze.crm_cust_info
		from 'E:\s work\SQL\project material\data warehouse projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);


		--#############2

		TRUNCATE TABLE Bronze.crm_prd_info;
		BULK INSERT Bronze.crm_prd_info
		from 'E:\s work\SQL\project material\data warehouse projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);


		--##############3
	
		TRUNCATE TABLE Bronze.crm_sales_detail;
		BULK INSERT Bronze.crm_sales_detail
		from 'E:\s work\SQL\project material\data warehouse projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);


		PRINT '-------------------------------------------------------------------';
		PRINT ' LOADING ERP TABLES';
		PRINT '-------------------------------------------------------------------';

		--##############4
		
		TRUNCATE TABLE dbo.Bronze_erp_cust_az12;
		BULK INSERT dbo.Bronze_erp_cust_az12
		from 'E:\s work\SQL\project material\data warehouse projects\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--#############5
	
		TRUNCATE TABLE dbo.Bronze_erp_loc_a101;
		BULK INSERT dbo.Bronze_erp_loc_a101
		from 'E:\s work\SQL\project material\data warehouse projects\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--##############6
	
		TRUNCATE TABLE dbo.Bronze_erp_px_cat_g1v2;
		BULK INSERT dbo.Bronze_erp_px_cat_g1v2
		from 'E:\s work\SQL\project material\data warehouse projects\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

	END TRY 
	BEGIN CATCH
			PRINT'--------------------------------------------------'
			PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
			PRINT 'Error Message' + ERROR_MESSAGE();
			PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
			PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
			PRINT '-------------------------------------------------'
	END CATCH
END