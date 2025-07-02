
use WareHouseOne

insert into silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,   
    sls_sales,
    sls_quantity,
    sls_price
)
--Transformed data
SELECT sls_ord_num
      ,trim(sls_prd_key) as sls_prd_key
      ,sls_cust_id
      ,CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL --check for invalid data 
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) --data type casting
        END sls_order_dt
      ,CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END sls_ship_dt
      ,CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END as sls_due_dt
      ,case when sls_sales is null or sls_sales <= 0 or  sls_sales != sls_quantity * abs(sls_price)-- handle the the invalid data data 
        then sls_quantity * abs(sls_price)
            else  sls_sales
        end as sls_sales --recalculate sales if the original value is missing or incorrect 
      , sls_quantity /*Quantity*/
      ,case when sls_price is null or sls_price <= 0
        then sls_sales / nullif(sls_quantity, 0)
         else sls_price
        end as sls_price -- Derive price if original value is invalid 
  FROM bronze.crm_sales_details; 

  ----------------------------------------------------------------------------------------
  select * from silver.crm_sales_details;
  ----------------------------------------------------------------------------------------
