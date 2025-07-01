use WareHouseOne; 

-----<=======>----Data Quality Checks queries-----=======>
-----------------------------------------------------------
-----<=======>----Bronze Layer cust_info Data Quality Checks queries-----=======>\


---------CHECK FOR UNWANTED SPACES----------- 
--Expectation= no result 
SELECT 
cst_firstname, cst_lastname
from bronze.crm_cust_info
where cst_firstname !=trim(cst_firstname) 

------Data standardization and consistency---------
--marital status 
SELECT DISTINCT cst_marital_status
from bronze.crm_cust_info
---gender----
SELECT DISTINCT cst_gndr
from bronze.crm_cust_info


-----<=======>----BRONZE Layer PRD_info Data check queries-----=======>
--<==-------------===>----------------====>-----------====>
  --==--TRANSFORM QUERIES------==--

  --checkign for unwanted space in prd_nm 
  select prd_nm 
    from  bronze.crm_prd_info
        where prd_nm  != trim(prd_nm) ; --use trim() to remove unwanted spaces 

--Check for NULLS or NEGATIVE numbers
 --Expectation is no resluts 
   select * --prd_cost  
    from  bronze.crm_prd_info
        where prd_cost < 0 OR prd_cost IS NULL;

--Data standardization and consistency
SELECT DISTINCT prd_line, 
    case upper(trim(prd_line)) --remove spaces if any using trim(), set to upper case if lower case using upper()
        when 'M' then 'Mountain'  
	    when 'R' then 'Road'
        when 'S' then 'Other Sales'
        when 'T' then 'Touring'
    else 'n/a'
    end prd_line
from bronze.crm_prd_info; 


--Check for Invalid date order/s
--end date should not be earlier than start date 
select * from bronze.crm_prd_info
 where prd_end_dt < prd_start_dt

 --End-date -> Start date of the 'NEXT' Record  -1 
 /*In SQL if you are at specific Rec and you want to access another information 
 from another record and for that we have two amazing window functions 
    --> we have the:
                Lead() and 
                lag() in this scenario we want to access the next records 
                that's why we have to go with the function lead().

        The lead of the start date so we want the start date of the next records
        and we have to partition the data*/
 select 
    prd_id,
    prd_key,
    prd_nm, 
    prd_start_dt,
    prd_end_dt,
   lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as prd_end_dt_test
  from bronze.crm_prd_info
  where prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509'); 


--<=======>SILVER LAYER Data Quality Checks=======>

--<=====>---Silver Layer CUST_info Data Quality Checks queries---=====>
                  
SELECT 
cst_id, cst_gndr, cst_firstname
from silver.crm_cust_info; 

-------------------------------------------------------------------
SELECT * from silver.crm_cust_info;

SELECT 
	cst_id, COUNT(*) as count 
from silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-----check for unwanted spaces lastname-------------------
SELECT 
*
from silver.crm_cust_info; 

SELECT 
cst_lastname
from silver.crm_cust_info
where cst_lastname != trim(cst_lastname)
----------------check for gender ------------------------
SELECT 
cst_gndr
from silver.crm_cust_info
where cst_gndr != trim(cst_gndr)


 ---================QUALITY CHECKS======================---
 --Check for NULLs and Duplicats in Primary Key 
 -- Expectation:No result 
 SELECT 
 prd_id,
 count(*)
 from silver.crm_prd_info
 group by prd_id
 having count(*) > 1 or prd_id is null

 --Check for Unwanted spaces 
 -- Expectation:No result 
 SELECT 
 prd_nm
 from silver.crm_prd_info
 where prd_nm != trim(prd_nm); 

 --Check for Nulls and negative Numbers 
 -- Expectation:No result 
 SELECT 
    prd_cost  --*
from  silver.crm_prd_info
where prd_cost < 0 OR prd_cost IS NULL;

--Data standardization and consistency
SELECT DISTINCT prd_line
from silver.crm_prd_info;   

--Check for invalid date order
    --Expectation: Show prodcts
    select *
    from silver.crm_prd_info
    where prd_start_dt < prd_end_dt
    --Expectation: Show NO prodcts
    select *
    from silver.crm_prd_info
    where prd_start_dt !< prd_end_dt

-----<=======>----SALES_details Data Quality Checks queries-----=======>\

SELECT TOP 1000 * from bronze.crm_sales_details

select * from bronze.crm_sales_details;

select sls_ord_num, count(*)
from bronze.crm_sales_details
group by sls_ord_num
having count(*) > 1 or sls_ord_num is null;

select sls_prd_key, count(*)
from bronze.crm_sales_details
group by sls_prd_key
having count(*) > 1 or sls_prd_key is null; 

select sls_cust_id, count(*)
from bronze.crm_sales_details
group by sls_cust_id
having count(*) > 1 or sls_cust_id is null */

--=========---------------------------------------------------=========
--=========---------------------------------------------------=========
SELECT TOP 1000 * from bronze.erp_cust_az12
SELECT TOP 1000 * from bronze.erp_loc_a101
SELECT TOP 1000 * from bronze.erp_px_cat_g1v2

