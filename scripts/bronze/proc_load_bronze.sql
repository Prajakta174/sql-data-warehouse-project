/*
=======================================================
Stored Procedure : Load Bronze Layer (source-> Bronze)
=======================================================
Script Purpose :
This stored procedure loads data into 'bronze' schema from external csv files.
It perfoems the following actions:
-Truncate the bronze tables before loading data .
-Uses the 'BULK INSERT' command to load data from csv files to bronze tables.

Parameters:
None.
This stored proceduure does not accept any parameters or return any values .

Usage Example:
EXEC bronze.load_brnze;
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN 
	DECLARE @start_time DATETIME,@end_time DATETIME , @batch_start_time DATETIME,@batch_end_time DATETIME;
	BEGIN TRY

SET @batch_start_time=GETDATE();
PRINT '=========================';
PRINT'Loading Bronze Layer';
PRINT '==========================';

PRINT'--------------------------------';
PRINT'Loading CRM Tables';
PRINT'---------------------------------';

SET @start_time=GETDATE();
PRINT'>>Truncating tables : bronze.crm_cus_info';
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\praja\OneDrive\Desktop\sql\dwh_project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> Load Duration : '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
PRINT'---------------------------------------------'


SET @start_time=GETDATE();
PRINT'>>Truncating tables : bronze.crm_prod_info';
TRUNCATE TABLE bronze.crm_prod_info;
BULK INSERT bronze.crm_prod_info
FROM 'C:\Users\praja\OneDrive\Desktop\sql\dwh_project\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> Load Duration : '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
PRINT'--------------------------------------------------------------------------------------------'

SET @start_time=GETDATE();
PRINT'>>Truncating tables : bronze.crm_sailes_details';
--Seperate steps perform due to error in csv to convert date 
TRUNCATE TABLE bronze.crm_sales_details_raw;
TRUNCATE TABLE bronze.crm_sales_details;
TRUNCATE TABLE bronze.crm_sales_details_error;
-- Load raw
BULK INSERT bronze.crm_sales_details_raw
FROM 'C:\Users\praja\OneDrive\Desktop\sql\dwh_project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

---------------------------------------
-- Insert GOOD rows into clean table
---------------------------------------
INSERT INTO bronze.crm_sales_details
SELECT
    sls_ord_num,
    sls_prd_key,
    TRY_CONVERT(INT, sls_cust_id),
    TRY_CONVERT(DATE, sls_order_dt, 112),
    TRY_CONVERT(DATE, sls_ship_dt, 112),
    TRY_CONVERT(DATE, sls_due_dt, 112),
    TRY_CONVERT(INT, sls_sales),
    TRY_CONVERT(INT, sls_quantity),
    TRY_CONVERT(INT, sls_prize)
FROM bronze.crm_sales_details_raw
WHERE TRY_CONVERT(DATE, sls_order_dt, 112) IS NOT NULL;
---------------------------------------
-- Store BAD rows
---------------------------------------


PRINT'>>Truncating tables : bronze.error_file';
INSERT INTO bronze.crm_sales_details_error
(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_prize
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_prize
FROM bronze.crm_sales_details_raw
WHERE TRY_CONVERT(DATE, NULLIF(sls_order_dt,''), 112) IS NULL;
SET @end_time=GETDATE();
PRINT'>> Load Duration : '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
PRINT'--------------------------------------------------------------------------------------------'


SET @start_time=GETDATE();
PRINT'>>Truncating tables : bronze.erp_loc_a101';
TRUNCATE TABLE bronze.erp_loc_a101;
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\praja\OneDrive\Desktop\sql\dwh_project\datasets\source_erp\loc_a101.csv'
WITH (
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> Load Duration : '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
PRINT'--------------------------------------------------------------------------------------------'


SET @start_time=GETDATE();
	PRINT'>>Truncating tables : bronze.erp_cust_az12';
TRUNCATE TABLE bronze.erp_cust_az12;
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\praja\OneDrive\Desktop\sql\dwh_project\datasets\source_erp\cust_az12.csv'
WITH (
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
);SET @end_time=GETDATE();
PRINT'>> Load Duration : '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
PRINT'--------------------------------------------------------------------------------------------'


SET @start_time=GETDATE();
PRINT'>>Truncating tables : bronze.erp_px_cat_g1v2';
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\praja\OneDrive\Desktop\sql\dwh_project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> Load Duration : '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
PRINT'--------------------------------------------------------------------------------------------'

SET @batch_end_time=GETDATE();
PRINT '==================================================='
PRINT'Loading Bronze Layer is completed '
PRINT'>>Total Load Duration : '+CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR)+'seconds';
PRINT'======================================================='
END TRY
BEGIN CATCH 
PRINT '============================================='
PRINT'Error ocure during loading broze layer '
PRINT 'Error Message '+ERROR_MESSAGE() ;
PRINT 'Error Message '+CAST(ERROR_NUMBER() AS NVARCHAR);
PRINT'=============================================='
END CATCH

END
