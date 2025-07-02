use WareHouseOne; 

/*
============================================================================================
DDL Script : CreateS Silver tables 
============================================================================================
Script purpose:
    This script creates tables is the 'silver' schema, dropping existing tables if they already exist.
    Run this script to re-define the DDL structure of 'silver' tables 
=============================================================================================
*/

--=========================================================
--CRM Silver DDl--
--=========================================================

-- silver layer customer info table--
IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
  DROP TABLE silver.crm_cust_info;
GO

create table silver.crm_cust_info(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50), 
cst_gndr nvarchar(50), 
cst_create_date date,
dwh_create_date DATETIME2 DEFAULT GETDATE()--EXTRA COULMN FOR METADATA (metedata coulmn)
); 

select * from silver.crm_cust_info;

-- silver layer product_info table--
if OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
  DROP TABLE silver.crm_prd_info;
GO
  
create table silver.crm_prd_info(
prd_id int, 
prd_key nvarchar(50),
cat_id nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt date,
prd_end_dt date,
dwh_create_date DATETIME2 DEFAULT GETDATE()
); 

select * from silver.crm_prd_info; 

--- silver layer sales details info table DDL---
if OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
  DROP TABLE silver.crm_sales_details;
GO
  
create table silver.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,   
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date DATETIME2 DEFAULT GETDATE() -- automatica datetime generated when the this table is loaded
); 

select * from silver.crm_sales_details; 

--================================================
-- ERP DDL--
--================================================  
--- silver layer cust_az12 ---
if OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
  DROP TABLE silver.erp_cust_az12;
GO  
  
create table silver.erp_cust_az12(
cid nvarchar(50), 
bdate date, 
gen nvarchar(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
); 

if OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
  DROP TABLE silver.erp_loc_a101;
GO
  --- silver layer erp_loc_a101 table ---
create table silver.erp_loc_a101(
cid	nvarchar(50), 
cntry nvarchar(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
); 

if OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
  DROP TABLE silver.erp_px_cat_g1v2;
GO
--- silver layer erp_px_cat_g1v2 ---  
create table silver.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
); 
