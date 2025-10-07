/*
==============================================================================================
customer report
==============================================================================================
purpose: 
	- this report consolidates key customer metrics and behaviours

highlights:
	1. gathers essential fields such as names, ages, and transaction details
    2. segments customers into categories (VIP, Regular, Now) and age groups
    3. aggregates customer-level metrics:
		- total orders 
        - total sales 
        - total quantity purchased 
        - total products 
        - lifespan (in months)
	4. calculate valuable KPIs:
		- recency (months since last order)
        - average order values
        - average monthly spend 
==============================================================================================
*/
/*--------------------------------------------------------------------------------------------
1) base query: retrieve core columns from tables 
--------------------------------------------------------------------------------------------*/
create view gold.report_consumers as 
with base_query as (
select 
o.order_id,
o.product_key,
o.order_date,
o.sales_amount,
o.quantity,
c.customer_key,
concat(c.first_name, ' ', c.last_name) as customer_name,
YEAR(CURDATE()) - birthdate AS age
from gold.fact_orders o
left join gold.dim_customers c
on c.customer_key = o.customer_key
where o.order_date is not null
),
customer_aggregation as (
/*-------------------------------------------------------------------------------------------
2) customer aggregations: summarizes key metrics at the customer level
--------------------------------------------------------------------------------------------*/
select 
	customer_key,
	customer_name,
	age,
	count(distinct order_id) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	count(distinct product_key) as total_products,
	max(order_date) as last_order_date,
	timestampdiff(month, min(order_date), max(order_date)) as lifespan
from base_query
group by 
	customer_key,
	customer_name,
	age
    )
select 
	customer_key,
	customer_name,
	age,
    case when age <20 then 'Under 20'
		 when age between 25 and 34 then '25-34'
         when age between 35 and 44 then '35-44'
         when age between 45 and 54 then '45-54'
         when age between 55 and 64 then '55-64'
         else '65 and above'
	end age_group,
    case when lifespan >= 4 and total_sales > 2000 then 'VIP'
		 when lifespan >= 4 and total_sales <= 2000 then 'Regular'
		 else 'New'
	end customer_segment,
    last_order_date,
    timestampdiff(month, last_order_date, now()) as recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	lifespan,
    -- compute average order value
    case when total_sales = 0 then 0
		 else total_sales / total_orders 
	end as avg_order_value,
    -- compute average monthly spend 
    case when lifespan = 0 then total_sales
		 else total_sales / lifespan 
	end as avg_monthly_spend
from customer_aggregation;

