USE WareHouseOne;

/*
EXECUTE: select * from gold.dim_customers;
*/

GO

CREATE VIEW gold.dim_customers AS

SELECT 
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,--you always need a PK for a dimension
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name, 
    ci.cst_lastname AS last_name, 
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the master for gender
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la ON ci.cst_key = la.cid;
GO

/* DATA QUALITY CHECKERS 


---CHECKER CHECKER -----CHECKER----CHECKER---
--After joining table, check if any duplicates were introduced by the join logic
--Check if there are any duplicates in the aggregated data using GROUP BY
select cst_id, count(*) from
		(select 
			ci.cst_id,
			ci.cst_key,
			ci.cst_firstname, 
			ci.cst_lastname, 
			ci.cst_marital_status,
			ci.cst_gndr,
			ci.cst_create_date,
			ca.bdate,
			ca.gen, 
			la.cntry
		from silver.crm_cust_info as ci
		left join silver.erp_cust_az12 as ca
		on		ci.cst_key = ca.cid
		left join silver.erp_loc_a101 as la
		on		ci.cst_key = la.cid
	)t GROUP BY cst_id
	HAVING COUNT(*) > 1 

---CHECKER CHECKER -----CHECKER----CHECKER---
--Data Integration
--NULLS often comes from joined tables. 
--NULL will appear if SQL finds no match when tables are joined. 
select distinct
		ci.cst_gndr,
		ca.gen,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --CRM IS THE MASTER FOR GENDER INFORMATION
			 ELSE COALESCE(ca.gen, 'n/a')
		END AS new_gndr
	from silver.crm_cust_info as ci
	left join silver.erp_cust_az12 as ca
	on		ci.cst_key = ca.cid
	left join silver.erp_loc_a101 as la
	on		ci.cst_key = la.cid	
	order by 1,2
