use WareHouseOne; 

/*
============================================================================================
DDL Scripta : Create Bronze tables 
============================================================================================
Script purpose:
    This script creates tables is the 'bronze' schema, dropping existing tables if they already exist.
    Run this script to re-define the DDL structure of 'bronze' tables 
=============================================================================================
*/

--=========================================================
--CRM DDl--
--=========================================================
IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
  DROP TABLE bronze.crm_cust_info;
GO

create table bronze.crm_cust_info(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50), 
cst_gndr nvarchar(50), 
cst_create_date date 
); 

select * from bronze.crm_cust_info; 

if OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
  DROP TABLE bronze.crm_prd_info;
GO
  
create table bronze.crm_prd_info(
prd_id int, 
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime
); 

select * from bronze.crm_prd_info; 


if OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
  DROP TABLE bronze.crm_sales_details;
GO
  
create table bronze.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
); 

select * from bronze.crm_sales_details; 

--================================================
-- ERP DDL--
--================================================  
if OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
  DROP TABLE bronze.erp_cust_az12;
GO
  
create table bronze.erp_cust_az12(
cid nvarchar(50), 
bdate date, 
gen nvarchar(50),
); 

if OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
  DROP TABLE bronze.erp_loc_a101;
GO
  
create table bronze.erp_loc_a101(
cid	nvarchar(50), 
cntry nvarchar(50),
); 

if OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
  DROP TABLE bronze.erp_px_cat_g1v2;
GO
  
create table bronze.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50)
); 
