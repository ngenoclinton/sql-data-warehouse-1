use WareHouseOne; 
--QUERIES THAT DOES DATA TRANSFORMATIONS AND DATA CLEANSING--
--rank values based on create dates only pick the highest on/lates ==>use window functions 
--removing duplcates 

SELECT 
cst_id, 
cst_key,
trim(cst_firstname) as customer_firstname,
trim(cst_lastname) as customer_lastname,
case when upper(trim(cst_marital_status)) = 'S' then 'Single'
	 when upper(trim(cst_marital_status)) ='M' then 'Married'
	else 'n/a'
end cst_marital_status,
case when upper(trim(cst_gndr)) = 'F' then 'Female'
	 when upper(trim(cst_gndr)) ='M' then 'Male'
	else 'Unknown'
end cst_gndr,
cst_create_date
from (
	SELECT 
	*, 		 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	from bronze.crm_cust_info
	WHERE cst_id is not null
)t where flag_last = 1 

------------------------------------------------------------------------
------------------------------------------------------------------------

--check for nulls and duplicats in the primary key 
-- expectation no result 
-- STEPS TO CHECK => aggregate the primary key 
-----------------------------------------------------------
SELECT 
	cst_id, COUNT(*) as count 
from bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL
  
---------CHECK FOR UNWANTED SPACES----------- 
--Expectation= no result 
SELECT 
cst_firstname, cst_lastname
from bronze.crm_cust_info
where cst_firstname !=trim(cst_firstname) 

-------------checl for unwanted spaces lastname-------------------
SELECT 
cst_lastname
from bronze.crm_cust_info
where cst_lastname != trim(cst_lastname)
----------------check for gender ---------------------------------
SELECT 
cst_gndr
from bronze.crm_cust_info
where cst_gndr != trim(cst_gndr)
-------------------------------------------------------------------------------
------Data standardization and consistency---------
--marital status 
SELECT DISTINCT cst_marital_status
from bronze.crm_cust_info
---gender----
SELECT DISTINCT cst_gndr
from bronze.crm_cust_info
