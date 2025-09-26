/*
=============================================================================
quality checks
=============================================================================
script purpose:
  this script performs various quality checks to validate the integrity, consistency and accuracy of the gold layer: these checks ensure:
  - uniqueness of surrogate keys in dimension tables.
  - unwanted spaces in string fields.
  - referential integrity between fact and dimension tables.
  - validation of relationships in the data model for analytical purposes.

usage notes;
  - run these checks after data loading gold layer.
  - investigate and resolve any discrepancies found during the checks 
=============================================================================
*/

-- ===========================================================
-- checking 'gold.dim_customers'
-- ===========================================================
-- check for uniqueness of customer key in gold.dim_customers
-- expectation: no result
select
	customer_key,
    count(customer_key)
from gold.dim_customers
group by customer_key
having customer_key is null
or count(customer_key) >1;

-- ===========================================================
-- checking 'gold.product_key'
-- ===========================================================
-- check for uniqueness of product key in gold.dim_products
-- expectation: no results 
select
	product_key,
    count(product_key)
from gold.dim_products
group by product_key
having product_key is null
or count(product_key) >1; 

-- ===========================================================
-- checking 'gold.fact_orders'
-- ===========================================================
-- check the data model connectivity between fact and dimensions 
select * 
from gold.fact_orders
left join gold.dim_customers
using (customer_key)
left join gold.dim_products 
using (product_key)
where customer_key is null or product_key is null;
