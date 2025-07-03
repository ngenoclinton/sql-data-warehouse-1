use WareHouseOne

insert into silver.erp_loc_a101(cid, cntry)
SELECT  
    replace(cid, '-', '') cid
    ,
    case 
        when trim(cntry) ='DE' then 'Germany'
        when trim (cntry) in ('US','USA') then 'United States'
        when trim(cntry) = '' or cntry is null then 'N/A'
       else trim(cntry)
    end as cntry
  FROM bronze.erp_loc_a101;


/* CHECKERS CODE ----*/

/* 
----Checkers----checkers --- checkers -----
SELECT  
       replace(cid, '-', '') cid
      ,cntry
  FROM bronze.erp_loc_a101   where replace(cid, '-', '') not in
     (select cst_key from silver.crm_cust_info);
----Checkers----checkers --- checkers -----

SELECT *
  FROM silver.crm_cust_info
  where cst_key not in (select cid from bronze.erp_loc_a101);

  -------Checkers----checkers --- checkers -----
  --DAta standardization and consisntency 
  SELECT  distinct
  
  cntry as cntry_old,
  case 
    when trim(cntry) ='DE' then 'Germany'
    when trim (cntry) in ('US','USA') then 'United States'
    when trim(cntry) = '' or cntry is null then 'N/A'
    else trim(cntry)
   end as cntry
  FROM bronze.erp_loc_a101 order by cntry;

