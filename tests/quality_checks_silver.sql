/*
=============================================================================
quality checks
=============================================================================
script purpose:
  this script performs various quality checks for data consistency, accuracy,
  and standardization across the 'silver' schemas: it include checks for:
  - null or duplicate primary keys,
  - unwanted spaces in string fields.
  - data standardization and consistency.
  - data consistency between related fields.

usage notes;
  - run these checks after data loading silver layer.
  - investigate and resolve any discrepancies found during the checks 
=============================================================================
*/

-- ===========================================================
-- checking 'silver.csv_customers'
-- ===========================================================
-- check for nulls or duplicates in primary key
-- expectation: no result
select 
  customer_id,
  count(customer_id)
from silver.csv_customer
group by (customer_id)
having customer_id is Null 
or count(customer_id) > 1;

-- check for unwanted spaces
-- expectation: no results
select 
	first_name,
	last_name
from silver.csv_customer
where trim(first_name) != first_name
or    trim(last_name) !=  last_name;

-- data standardization & consistency 
select 
      YEAR(CURDATE()) - birth_year AS age,
        CASE 
           WHEN YEAR(CURDATE()) - birth_year < 25 THEN '18-24'
           WHEN YEAR(CURDATE()) - birth_year < 35 THEN '25-34'
           WHEN YEAR(CURDATE()) - birth_year < 45 THEN '35-44'
           WHEN YEAR(CURDATE()) - birth_year < 55 THEN '45-54'
           WHEN YEAR(CURDATE()) - birth_year < 65 THEN '55-64'
           ELSE '65+'
		end as age_category,
        CASE WHEN UPPER(TRIM(gender)) = 'F' THEN 'Female'
             WHEN UPPER(TRIM(gender)) = 'M' THEN 'Male'
             ELSE 'n/a'
        END AS gender,
        CASE WHEN UPPER(country) = 'CA' THEN 'Canada'
             WHEN UPPER(country) = 'UK' THEN 'United Kingdom'
             WHEN UPPER(country) = 'DE' THEN 'Germany'
             WHEN UPPER(country) = 'FR' THEN 'France'
             WHEN UPPER(country) = 'AU' THEN 'Australia'
             WHEN UPPER(country) = 'US' THEN 'United States'
             ELSE 'n/a'
        END AS country
        from silver.csv_customer;
        
-- ===========================================================
-- checking 'silver.csv_orders'
-- ===========================================================
-- check for nulls or duplicates in primary key
-- expectation: no result
select 
  order_id,
  count(order_id)
from silver.csv_orders
group by (order_id)
having order_id is Null 
or count(order_id) > 1;

-- data standardization & consistency
select
	SUBSTRING(order_id,5,6) AS order_id,
	SUBSTRING(customer_id,6,5) AS customer_id,
	DATE_FORMAT(order_date,'%Y') AS order_year,
	DATE_FORMAT(order_date,'%b') AS order_month,
	DATE_FORMAT(order_date,'%d') AS order_day,
	CASE 
		WHEN UPPER(billing_country) = 'CA' THEN 'Canada'
		WHEN UPPER(billing_country) = 'UK' THEN 'United Kingdom'
		WHEN UPPER(billing_country) = 'DE' THEN 'Germany'
		WHEN UPPER(billing_country) = 'FR' THEN 'France'
		WHEN UPPER(billing_country) = 'AU' THEN 'Australia'
		WHEN UPPER(billing_country) = 'US' THEN 'United States'
		ELSE 'n/a'
	END AS billing_country
FROM bronze.csv_orders;

-- check data consistency
-- >> quantity, unit_price, line_total
-- >> values must not be null, zero, or negative.
-- expectation: no results
select 
	subtotal,
    discount_amount,
    shipping_cost,
    tax_amount,
    total_amount
from silver.csv_orders
where (subtotal is null or discount_amount is null or shipping_cost is null or tax_amount is null or total_amount is null)
or 
(subtotal =0 or tax_amount =0 or total_amount =0)
or
(subtotal <0 or discount_amount <0 or shipping_cost <0 or tax_amount <0 or total_amount <0); 

-- check for invalid date orders
-- expectation: no results
select 
distinct order_year
from silver.csv_orders
where order_year< 2023;

-- ===========================================================
-- checking 'silver.csv_order_items'
-- ===========================================================
-- check for nulls or duplicates in primary key
-- expectation: no result
select 
  order_item_id,
  count(order_item_id)
from silver.csv_order_items
group by (order_item_id)
having order_item_id is Null 
or count(order_item_id) > 1;

-- check data consistency
-- >> quantity, unit_price, line_total
-- >> values must not be null, zero, or negative.
-- expectation: no results
select 
	quantity,
    unit_price,
    line_total
from silver.csv_order_items
where (quantity is null or unit_price is null or line_total is null)
or 
(quantity =0 or unit_price =0 or line_total =0)
or
(quantity <0 or unit_price <0 or line_total <0); 

-- ===========================================================
-- checking 'silver.csv_products'
-- ===========================================================
-- check for nulls or duplicates in primary key
-- expectation: no result
select 
  product_id,
  count(product_id)
from silver.csv_products
group by (product_id)
having product_id is Null 
or count(product_id) > 1;

-- data standardization & consistency
SELECT 
	SUBSTRING(product_id,6,4) AS product_id,
	TRIM(SUBSTRING_INDEX(product_name, ' ', -3)) AS product_name,
	DATE_FORMAT(launch_date,'%Y') AS launch_year,
	DATE_FORMAT(launch_date,'%b') AS launch_month
FROM bronze.csv_products;
    

