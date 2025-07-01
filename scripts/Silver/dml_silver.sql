USE WareHouseOne; 

--QUERIES THAT DOES DATA TRANSFORMATIONS AND DATA CLEANSING--
--rank values based on create dates only pick the highest on/lates ==>use window functions 
--removing duplcates 
insert into silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date )

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

