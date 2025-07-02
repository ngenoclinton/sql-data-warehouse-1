use WareHouseOne

  ---CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS--
  ----------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------
  --Checking with product information--
  SELECT * FROM bronze.crm_sales_details;
  
  --checking for sales product information not in the customer product information
  --Expection: not result 
  SELECT top 10 * FROM bronze.crm_sales_details;
    
  SELECT *, sls_prd_key
  FROM bronze.crm_sales_details
  where sls_prd_key not in (select prd_key from silver.crm_prd_info); 


  ---CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS--
 ---------CHECK FOR UNWANTED SPACES ----------- 
--Expectation= no result 
SELECT 
     *, sls_prd_key
from bronze.crm_sales_details
where sls_prd_key != trim(sls_prd_key) 
-----------------------------------------------

---CHECKERS---------------CHECKERS-------CHECKERS-----CHECKERS--
---CHECK FOR Invalid dates ----------- 
--Expectation= no result but  in cases of ivalid clean the data
--the dates are in integer type not valid dates 
SELECT top 10 *, sls_order_dt FROM bronze.crm_sales_details;

SELECT 
     *, sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 

select *, nullif(sls_order_dt, 0) sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 OR len(sls_order_dt) !=8
    OR sls_order_dt > 20500101
    OR sls_order_dt < 19500101

select *, nullif(sls_ship_dt, 0) sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt <= 0 OR len(sls_ship_dt) !=8
    OR sls_ship_dt > 20500101
    OR sls_ship_dt < 19500101

select *, nullif(sls_due_dt, 0) sls_due_dt
from bronze.crm_sales_details
where sls_due_dt <= 0 OR len(sls_due_dt) !=8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19500101

select *
from bronze.crm_sales_details
where  sls_order_dt > sls_ship_dt or sls_ship_dt > sls_due_dt; 

--------------------------------------------
---CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS--
    --Check data consistency: Between Sales, Quantity and Price 
    --- >> Sales, Quantity and Price 
    --- >> Values must not be NULL, Zero, or negative 
    --Expectation= no result but  in cases of ivalid clean the data
SELECT Distinct
     sls_sales as old_sls_sales,  
     sls_quantity,  
     sls_price as old_sls_price, 

case when sls_sales is null or sls_sales <= 0 or  sls_sales != sls_quantity * abs(sls_price)
    then sls_quantity * abs(sls_price)
    else  sls_sales
end sls_sales,
case when sls_price is null or sls_price <= 0
    then sls_sales / nullif(sls_quantity, 0)
    else sls_price
end sls_price

from bronze.crm_sales_details

where 
sls_sales != sls_quantity * sls_price or
sls_sales is null or  sls_quantity is null or sls_price is null or
sls_sales <= 0 or  sls_quantity <= 0 or sls_price <= 0
order by sls_sales,  sls_quantity,  sls_price

--RULES--
 --1. If sales is negative, zero, or null, derive it using Quantity and price
 --2. If price is zero or null, calculate it using Sales and Quantity
 --3. If price is negative, convert it to positive value 
    
--In the scenario above if issues are found there are two solutions:
    --:Sloution 1.--> Data issues will  be fixed directly in source systems 
    --:Soultion 2:--> Data issues have to be fixed in the warehouse 
--------------------------------------------------------------------

---CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS-----CHECKERS--
  SELECT top 4 *,
      prd_id, prd_key, cat_id
  FROM silver.crm_prd_info
    where prd_key in (select sls_prd_key from bronze.crm_sales_details)
  --------------------------------------------
  --Checking Customer information in sales inforMation--
  --------------------------------------------
  select *  FROM silver.crm_cust_info
 where cst_id in (select sls_cust_id from bronze.crm_sales_details); 
 --checking for products in sales information not in the customer customer information table
  --Expection: not result 
  SELECT top 10 *
  FROM silver.crm_cust_info

  SELECT  top 10 *, sls_cust_id
  FROM bronze.crm_sales_details
  where sls_cust_id  not in (select cst_id from silver.crm_cust_info); 

