/*
==================================================================================
Stored procedure: Load Bronze Layer (source -> Bronze 
==================================================================================

Scrpit purpose:
  This stored procedure loads data into the 'bronze' schema from the external csv source file. 
  It performs the following the following actions:
   -Truncate the bronze tables before loading data.
  -use the 'BULK INSERT (bulk insert)' command to load data from csv files to bronze tables 

Parameters:
    None.
    This store procedure does not accept any parameters or returns any values.

Usage Example:
  EXEC bronze.load_bronze 
==================================================================================
=================================================================================
*/


EXEC bronze.load_bronze; 
	

create or alter procedure bronze.load_bronze as 
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time DATETIME, @batch_end_time DATETIME;
	begin try 
	SET @batch_start_time = GETDATE(); 
		print '================================================================';
		print 'Loading bronze layer';
		print '================================================================';
	-- CRM STARTS HERE -- 

		print '----------------------------------------------------------------';
		print 'Loading CRM tables';
		print '----------------------------------------------------------------';

		set @start_time  = GETDATE(); 
			print '>> Truncating table: bronze.crm_cust__info';
			TRUNCATE TABLE bronze.crm_cust_info;

			print'>> Inserting data into: bronze.crm_cust_info';
			bulk insert bronze.crm_cust_info
			from 'C:\Users\user\Desktop\DATA ENGINEER\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			with (
				firstrow = 2,
				fieldterminator=',',
				tablock
			); 
		set @end_time = GETDATE();
		PRINT '>> lOADING DURATION: '  + CAST(DATEDIFF( second, @start_time, @end_time) as nvarchar) + 'seconds;
		print '---------------------------'

		set @start_time  = GETDATE();
			print '>> Truncating table: bronze.crm_prd_info';
			-- Clear existing data
			TRUNCATE TABLE bronze.crm_prd_info;

			print'>> Inserting data into:  bronze.crm_prd_info';
			bulk insert bronze.crm_prd_info
			from 'C:\Users\user\Desktop\DATA ENGINEER\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			with (
				firstrow = 2,
				fieldterminator=',',
				tablock
			); 
		set @end_time = GETDATE();
		PRINT '>> lOADING DURATION: '  + CAST(DATEDIFF( second, @start_time, @end_time) as nvarchar) + 'seconds;
		print '---------------------------'
		
		set @start_time  = GETDATE();
			print '>> Truncating table:  bronze.crm_sales_details';
			-- Clear existing data
			TRUNCATE TABLE bronze.crm_sales_details;
			print'>> Inserting data into:  crm_sales_details';
			bulk insert bronze.crm_sales_details
			from 'C:\Users\user\Desktop\DATA ENGINEER\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			with (
				firstrow = 2,
				fieldterminator=',',
				tablock
			);	
		set @end_time = GETDATE();
		PRINT '>> lOADING DURATION: '  + CAST(DATEDIFF( second, @start_time, @end_time) as nvarchar) + 'seconds;
		print '---------------------------'
		-- CRM ENDS HERE -- 

	
		print '----------------------------------------------------------------'
		print 'Loading CRM tables'
		print '----------------------------------------------------------------'

		-- ERP BEGINS HERE -- 

		set @start_time  = GETDATE();
			print '>> Truncating table:  bronze.erp_cust_az12'
			-- Clear existing data
			TRUNCATE TABLE bronze.erp_cust_az12;

			print'>> Inserting data into:  bronze.erp_cust_az12'
				bulk insert bronze.erp_cust_az12
			from 'C:\Users\user\Desktop\DATA ENGINEER\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
			with (
				firstrow = 2,
				fieldterminator=',',
				tablock
			); 
		set @end_time = GETDATE();
		PRINT '>> lOADING DURATION: '  + CAST(DATEDIFF( second, @start_time, @end_time) as nvarchar) + 'seconds;
		print '---------------------------'

		set @start_time  = GETDATE();
			print '>> Truncating table:  bronze.erp_loc_a101'
			-- Clear existing data
			TRUNCATE TABLE bronze.erp_loc_a101;
			print'>> Inserting data into:  bronze.erp_loc_a101'
			bulk insert bronze.erp_loc_a101
			from 'C:\Users\user\Desktop\DATA ENGINEER\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
			with (
				firstrow = 2,
				fieldterminator=',',
				tablock
			); 
		set @end_time = GETDATE();
		PRINT '>> lOADING DURATION: '  + CAST(DATEDIFF( second, @start_time, @end_time) as nvarchar) + 'seconds;
		print '---------------------------'

		set @start_time  = GETDATE();
			print '>> Truncating table:  bronze.erp_px_cat_g1v2'
			-- Clear existing data
			TRUNCATE TABLE bronze.erp_px_cat_g1v2;
			print'>> Inserting data into:  bronze.erp_px_cat_g1v2'
			bulk insert bronze.erp_px_cat_g1v2
			from 'C:\Users\user\Desktop\DATA ENGINEER\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
			with (
				firstrow = 2,
				fieldterminator=',',
				tablock
			); 
		set @end_time = GETDATE();
		PRINT '>> lOADING DURATION: '  + CAST(DATEDIFF( second, @start_time, @end_time) as nvarchar) + 'seconds;
		print '---------------------------'

		
		SET @batch_end_time = GETDATE();
		print '====================================================='
		PRINT ' lOADING BRONZE LAYER IS COMPLETED:';
		PRINT ' - tOTAL DURATION : '  + CAST(DATEDIFF( second, @batch_start_time, @batch_end_time) as nvarchar ) + 'seconds';
		print '====================================================='
	end try
	begin catch
		print '==========================================================';
		print 'Error Occured during loading bronze layer';
		print 'Error Message' + error_message();
		print 'Error Message' + cast(error_number() as nvarchar); 
		print 'Error Message ' + cast(error_state() as nvarchar);
		print '==========================================================';
	end catch

end; 
