
use WareHouseOne



PRINT '>>Truncating Table: silver.erp_px_cat_g1v2'; 
TRUNCATE TABLE silver.erp_px_cat_g1v2;
PRINT '>>Inserting Data Into: silver.erp_px_cat_g1v2';
insert into silver.erp_px_cat_g1v2(
    id
    ,cat
    ,subcat
    ,maintenance
)

SELECT id
      ,cat
      ,subcat
      ,maintenance
  FROM bronze.erp_px_cat_g1v2;

----Checks--checks----checks------
select * from silver.erp_px_cat_g1v2

