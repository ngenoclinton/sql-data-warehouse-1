USE WareHouseOne;
GO

CREATE VIEW gold.dim_products AS
   
SELECT 
    ROW_NUMBER() OVER (ORDER BY pd.prd_start_dt, pd.prd_id) AS product_key --you always need a PK for a dimension
    ,pd.prd_id as product_id
    ,pd.prd_key as product_number
    ,pd.prd_nm as product_name
    ,pd.cat_id as category_id
    ,pc.cat as category
    ,pc.subcat as subcategory
    ,pc.maintenance
    ,pd.prd_cost as cost
    ,pd.prd_line as product_line
    ,pd.prd_start_dt as start_date        
FROM silver.crm_prd_info AS pd
LEFT JOIN  silver.erp_px_cat_g1v2 as pc ON pd.cat_id = pc.id
WHERE pd.prd_end_dt is NULL ---fILTERS OUT ALL HISTORICAL DATA.



/* 
EXECUTE :  select * from gold.dim_products;
*/

--CHECKERS-------CHECKERS-----------CHECKERS------CHECKERS------
/* DATA QUALITY CHECKERS

select * from silver.crm_prd_info AS pd
  WHERE pd.prd_end_dt is NULL; 


  SELECT 
       id
      ,cat
      ,subcat
      ,maintenance
  FROM silver.erp_px_cat_g1v2
