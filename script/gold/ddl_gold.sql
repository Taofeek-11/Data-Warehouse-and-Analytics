/*
=======================================================================================================
DDL Script: create gold views
=======================================================================================================
script purpose:
  this script creates views for the 'gold' layer in the datawarehouse.
  the gold layer contains the final dimension and fact tables (star schema)

  each view performs transformatins and combines data from the silver layer 
  to produce a clear, enrinched, and business_ready dataset.

usage:
      these views can be queried directly fro analytics and reporting. 
=======================================================================================================
*/

-- ====================================================================================================
-- create dimension: gold.dim_customers
-- ====================================================================================================
drop view if exists gold.dim_customers;
create view gold.dim_customers as 
select
	row_number () over (order by customer_id) as customer_key,
	customer_id,
	first_name,
	last_name,
	age_category,
	gender,
	country,
	city,
	customer_segment
from silver.csv_customer;

-- ====================================================================================================
-- create dimension: gold.dim_products
-- ====================================================================================================
drop view if exists gold.dim_products;

create view gold.dim_products as 
select 
	row_number () over (order by product_id) as product_key,
	product_id,
	product_name,
	category,
	brand,
	price,
	cost,
	launch_year,
	launch_month,
	current_inventory,
	reorder_level
from silver.csv_products;

-- ====================================================================================================
-- create dimension: gold.dim_orders
-- ====================================================================================================
drop view gold.fact_orders;
create view gold.fact_orders as
select
	o.order_id,
	c.customer_key,
  p.product_key,
	o.order_year,
	o.order_month,
	o.order_day,
	o.order_status,
	oi.quantity,
	oi.unit_price,
  oi.line_total,
  o.subtotal,
	o.discount_amount,
	o.shipping_cost,
	o.tax_amount,
	o.payment_method,
	o.order_source,
	o.billing_country
from silver.csv_orders o
left join gold.dim_customers c
on o.customer_id=c.customer_id
left join silver.csv_order_items oi
on o.order_id= oi.order_id
left join gold.dim_products p
on oi.product_id=p.product_id;

