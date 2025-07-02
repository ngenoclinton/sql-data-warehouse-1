use WareHouseOne

INSERT INTO  silver.erp_cust_az12(
cid, 
bdate, 
gen
)
SELECT
       case when cid like 'NAS%' then substring(cid, 4, len(cid))
         else cid
       end as cid
      ,case when bdate > getdate () then null
        else bdate
       end as bdate 
      ,case when upper(trim(gen)) in ('F','FEMALE') THEN ('Female')
         when upper(trim(gen)) in ('M','MALE') THEN ('Female')
      else 'N/A'
     end as gender
  FROM bronze.erp_cust_az12

 
  /*

  -----Data quality Checkers Checkers ---
 SELECT * FROM silver.erp_cust_az12

SELECT * FROM bronze.erp_cust_az12


----------Checker ----- Checker ----- Checker ------
SELECT
       cid,
       case when cid like 'NAS%' then substring(cid, 4, len(cid))
         else cid
       end as cid
      ,bdate
      ,gen
  FROM bronze.erp_cust_az12
  --where
  where case when cid like 'NAS%' then substring(cid, 4, len(cid))
         else cid 
         end not in (select cst_key FROM silver.crm_cust_info);

-------------Checker ----- Checker ----- Checker ------
---Identify Out-Of-Range Dates.

SELECT
  bdate
  FROM bronze.erp_cust_az12
  where  bdate < '1994-01-01' or bdate > getdate(); 

  -------------Checker ----- Checker ----- Checker ------
---Data Standardization and consistency. 
SELECT distinct 
  gen
  , case when upper(trim(gen)) in ('F','FEMALE') THEN ('Female')
         when upper(trim(gen)) in ('M','MALE') THEN ('Female')
      else 'N/A'
     end as gender
  FROM bronze.erp_cust_az12 

*/
