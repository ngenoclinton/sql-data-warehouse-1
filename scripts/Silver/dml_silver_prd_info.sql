--DATA TRANSFORMATION QUERY--

--INSERT TRANSFORMED DATA -prd_info
insert into silver.crm_prd_info(
	prd_id,
    prd_key,
	cat_id,
	prd_nm,
	prd_cost,
	prd_line,   
	prd_start_dt,
    prd_end_dt
)
--DATA TRANSFORMATIONS--
SELECT 
        
       prd_id
      --,prd_key,
      ,substring(prd_key, 7, len(prd_key)) as prd_key -- derived coulmmn /* derived coulmmns-<> new columns created based on calculations or transforamtions of existing ones  */
      ,replace(substring(prd_key, 1,5),'-','_') as cat_id
      ,prd_nm
      ,isnull(prd_cost,0) as prd_cost --  check for nulls if null replace with 0 
      ,case upper(trim(prd_line)) --NORMALIZATION
            when 'M' then 'Mountain' --remove spaces if any, set to upper case when lower case 
	        when 'R' then 'Road'
            when 'S' then 'Other Sales'
            when 'T' then 'Touring'
        else 'n/a'
       end prd_line,
        cast(prd_start_dt as date) as prd_start_dt    --> casting 
      --,prd_end_dt
      ,cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 as date) as prd_end_dt --==> casting and Data enrichemnt <Add new relevant data to enhance the dataset for analysis>>
  FROM bronze.crm_prd_info; 

  SELECT COUNT(*) FROM bronze.crm_prd_info; 
