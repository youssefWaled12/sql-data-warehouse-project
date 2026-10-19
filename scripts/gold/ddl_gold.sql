CREATE VIEW gold.dim_customers as
SELECT 
	ROW_NUMBER() OVER(ORDER BY cst_id) AS Customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	la.cntry as country,
	ci.cst_material_status as matrial_status,
	CASE
		WHEN ci.cst_gndr!='n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen,'n/a')
	end as gender,
	ci.cst_create_date as create_date,
	ca.bdate as birthdate
FROM silver.crm_cust_info ci
LEFT join silver.erp_cust_az12 ca ON ci.cst_key= ca.cid
LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key= la.cid
------------------------------------------------------------------------
--dimension products
CREATE VIEW gold.dim_products as
SELECT
ROW_NUMBER()OVER( ORDER BY pn.prd_start_dt,pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as prodcut_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line  as product_line,
	pn.prd_start_dt as start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc on pn.cat_id=pc.id
WHERE prd_end_dt is NULL 
-------------------------------------------------------------------------------------------
--fact sales
CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quanity,
	sd.sls_price price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number
	LEFT JOIN gold.dim_customers cu
	ON sd.sls_cust_id=cu.customer_id



