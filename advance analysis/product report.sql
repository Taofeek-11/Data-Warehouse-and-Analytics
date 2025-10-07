/*
================================================================================================
product report 
================================================================================================
purpose:
	- this report consolidates key product metrics and behaviors.
highlights:
	1. gathers essential fields such as product name, category, subcategory, and cost.
    2. segments products by revenue to identify high-performers, mid-range, and lower_performers.
    3. aggregates product-level metrics.
		- total orders 
        - total sales 
        - total quantity sold
        - total customers (unique)
        - lifespan (in month)
	4. calculates valuable KPIs:
		- recency (months since last sales)
        - average order reveneu (AOR)
        - average monthly revenue 
=============================================================================================
*/
create view gold.report_products as 
with base_query as (
/*-------------------------------------------------------------------------------------------
1) base query: retrieves core columns from fact_sales and dim_product 
-------------------------------------------------------------------------------------------*/
select 
	o.order_number,
	o.order_date,
	o.customer_key,
	o.sales_amount,
	o.quantity,
	p.product_key,
    p.product_name,
	p.category,
	p.cost
from gold.fact_orders o
left join gold.dim_products p
	 on  o.product_key = p.product_key
where order_date is not null  -- only consider valid sales 
),
 product_aggregations as (
/*-------------------------------------------------------------------------------------------
2) product aggregations: summarizes key metrics at the product level
-------------------------------------------------------------------------------------------*/
select 
	product_key,
    product_name,
    category,
    cost,
    timestampdiff(month, min(order_date), max(order_date)) as lifespan,
    max(order_date) as last_sales_date,
    count(distinct order_number) as total_orders,
    count(distinct customer_key) as total_customers,
    sum(sales_amount) as total_sales,
    sum(quantity) as total_quantity,
    round(avg(cast(sales_amount as float) / nullif(quantity, 0)), 1) as avg_selling_price
from base_query
group by
	product_key,
    product_name,
    category,
    cost
    )
/*---------------------------------------------------------------------------------------
 3) final query: combines all product results into one output 
--------------------------------------------------------------------------------------*/
select 
	product_key,
    product_name,
    category,
    cost,
    last_sales_date,
    timestampdiff(month, last_sales_date, now()) as recency_in_sales,
    case when total_sales > 30000 then 'High_performer'
		 when total_sales > 10000 then 'Mid-Range'
         else 'Low-Performer'
	end as product_segement,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    -- average order revenue (AOR)
    case when total_orders = 0 then 0
		 else total_sales / total_orders
	end as avg_order_revenue,
	-- average monthly revenue 
    case when lifespan = 0 then total_sales
		 else total_sales / lifespan 
	end as avg_monthly_revenue 
from product_aggregations
    
