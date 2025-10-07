/*===========================================================================================================================
 exploratory and advanced analysis
=============================================================================================================================
 purpose:
  - explore all objects in the database and understand the relationships 
    and trends in the dataset.
 highlights:
  1. explore all columns in the database such as customers' country, product categories, first and last orders, and oldest 
and youngest customers. 
  2. calculate valuable KPIS
    - total sales
    - total quantity sold
    - total customers
    - total orders
  3. describe the characterisitics of customers: 
    - by gender
    - countries 
    - amount  
  4. ranking and time_change analysis
    - evaluate product based on sales
    - change over time 
  5. time-change analysis 
	- YoY order change
	- YoY sales and revenue change 
  6. cumulative analysis 
	- total sales by month & running total sales overtime
	- avg price by month & running avg price overtime
  7. perfromance analysis 
	- yearly performance of products
  8. proportional analysis 
    - category sales performance 
  9. data segmentation 
	- product segmentation by cost range
	- customer segmentation by spending behaviour
==============================================================================================================================================*/

/*----------------------------------------------------------------------------------------------------------------
 1) data exploration: exploring the characterisitcs of the columns of the database
-----------------------------------------------------------------------------------------------------------------*/
 -- all columns in the database
select * from information_schema.tables; 
select * from information_schema.columns
where table_name= 'dim_customers';

-- countries our customers come from 
select distinct country, city from gold.dim_customers;

-- product categories 
select distinct category, brand, product_name from gold.dim_products
order by 1, 2, 3; 

-- first and the last order date 
select 
	min(order_year) as first_order_date,
	max(order_year) as last_order_year,
	(max(order_year) - min(order_year)) as order_range_year
from gold.fact_orders;

-- youngest and the oldest customer 
select 
	min(age) as oldest_age,
	max(age) as youngest_age
from gold.dim_customers;

/*----------------------------------------------------------------------------------------------------------------
2) calculate valuable KPIS
-----------------------------------------------------------------------------------------------------------------*/

-- total sales 
select sum(quantity*unit_price) as total_sales from gold.fact_orders; 

-- total items sold
select sum(quantity) as total_quantity from gold.fact_orders; 

 -- total line unit 
 select sum(line_total) as total_line_units from gold.fact_orders;

-- average unit_price
select avg(unit_price) as avg_price from gold.fact_orders;

-- total number of orders
select count(order_number) as total_order from gold.fact_orders;
select count(distinct order_number) as total_order from gold.fact_orders;

-- total number of products 
select count(product_name) as total_product_name from gold.dim_products;
select count(distinct product_name) as total_product_name from gold.dim_products;

-- total number of customers
select count(distinct customer_key) as total_product_name from gold.dim_customers;

/*---------------------------------------------------------------------------------------------------------------------------------
-- a report of all key metrics of the business 
---------------------------------------------------------------------------------------------------------------------------------*/
select 'total_sales' as measure_name, sum(total_amount) as measure_value from gold.fact_orders
union all
select 'total_quantity' as measure_name, sum(quantity) as measure_value from gold.fact_orders
union all
select 'total_line_unit' as measure_name, sum(line_total) as measure_value from gold.fact_orders
union all 
select 'avg_unit_price' as measure_name, avg(unit_price) as measure_value from gold.fact_orders
union all
select 'total_subtotal' as measure_name, sum(subtotal) as measure_value from gold.fact_orders
union all
select 'total_discount_amount' as measure_name, sum(discount_amount) as measure_value from gold.fact_orders
union all
select 'total_shipping_cost' as measure_name, sum(shipping_cost) as measure_value from gold.fact_orders
union all
select 'total_tax' as measure_name, sum(tax_amount) as measure_value from gold.fact_orders
union all
select 'total_order' as measure_name, count(distinct order_number) as measure_value from gold.fact_orders
union all
select 'total_nr.product' as measure_name, count(distinct product_name) as measure_value from gold.dim_products
union all 
select 'total_nr.customer' as measure_name, count(distinct customer_key) as measure_value from gold.dim_customers
union all 
select 'total_nr.customer_that_placed_order' as measure_name, count(distinct customer_key) as measure_value from gold.fact_orders;

/*---------------------------------------------------------------------------------------------------------------------------
3) characterisitics of customers: describe customers by order, countries and gender  
---------------------------------------------------------------------------------------------------------------------------*/
-- total customers by countries;
select 
	country,
	count(customer_key) as total_customers
from gold.dim_customers
group by country
order by total_customers desc; 

-- total customers by gender 
select 
	gender,
	count(customer_key) as total_customer
from gold.dim_customers
group by gender
order by total_customer;

 -- total products by category
select 
	category,
	count(product_key) as total_product
from gold.dim_products
group by category
order by total_product;

 -- average costs in each category
select 
	category,
	avg(cost) as avg_cost
from gold.dim_products
group by category
order by avg_cost;

-- total revenue by category
select
	p.category,
	sum(o.total_amount) as total_revenue
from gold.fact_orders o
left join gold.dim_products p
on o.product_key = p.product_key
group by category
order by total_revenue;

-- total revenue generated by each customer
select 
	c.customer_key,
	c.first_name,
	c.last_name,
	sum(o.total_amount) as total_revenue
from gold.fact_orders o
left join gold.dim_customers c
on c.customer_key = o.customer_key
group  by 
	c.customer_key,
	c.first_name,
	c.last_name
order by total_revenue desc;

/*----------------------------------------------------------------------------------------------------------------
  4) ranking analysis: evaluate product based on sales 
-----------------------------------------------------------------------------------------------------------------*/
-- top 5 best-performing product by sales
select 
	p.product_name,
	sum(o.total_amount) total_revenue 
from gold.fact_orders o
left join gold.dim_products p
on p.product_key=o.product_key
group by p.product_name
order by total_revenue desc
limit 5;

-- 5 worst-performing products by sales
select 
p.product_name,
sum(o.total_amount) total_revenue 
from gold.fact_orders o
left join gold.dim_products p
on p.product_key=o.product_key
group by p.product_name
order by total_revenue asc
limit 5;

-- the 3 customers with the fewest orders placed
select 
	c.customer_key,
	c.first_name,
	c.last_name,
	count(o.order_id) total_orders
from gold.fact_orders o
left join gold.dim_customers c
on c.customer_key=o.customer_key
group by 
	c.customer_key,
	c.first_name,
	c.last_name
order by total_orders asc
limit 5;

/*----------------------------------------------------------------------------------------------------------------
 5) time-change analysis: evaluate changes over time
-----------------------------------------------------------------------------------------------------------------*/
-- YoY order change
select
	year(order_date) as order_year,
	month(order_date) as order_month,
	count(order_id) as total_order,
	sum(quantity) as total_quantity,
	sum(sales_amount) as total_sales,
	sum(total_amount) as total_revenue
from gold.fact_orders
group by year(order_date), month(order_date)
order by year(order_date), month(order_date);

-- total sales and revenue YOY change
select
	date_format(order_date, '%Y-%b-01') as order_year,
	count(order_id) as total_order,
	sum(quantity) as total_quantity,
	sum(sales_amount) as total_sales,
	sum(total_amount) as total_revenue
from gold.fact_orders
group by date_format(order_date, '%Y-%b')
order by date_format(order_date, '%Y-%b');

/*-------------------------------------------------------------------------------------------------------------------------
 6) cumulative analysis: evaluate sales changes over time
-------------------------------------------------------------------------------------------------------------------------*/
-- total sales per mont and the running total sales over time 
select 
	order_date,
	total_sales,
	sum(total_sales) over(partition by order_date order by order_date) as running_total_sales 
from
(
		select
		DATE_FORMAT(order_date, '%Y-%m-01') as order_date,
		count(order_id) as total_order,
		sum(quantity) as total_quantity,
		sum(sales_amount) as total_sales,
		sum(total_amount) as total_revenue
		from gold.fact_orders
		group by DATE_FORMAT(order_date, '%Y-%m-01')
		order by DATE_FORMAT(order_date, '%Y-%m-01')
)t;

-- avg price per month and the running avg price over time
select 
	order_date,
	avg_price,
	avg(avg_price) over(order by order_date) as moving_avg_price 
from
(
		select
		DATE_FORMAT(order_date, '%Y-%m-01') as order_date,
		count(order_id) as total_order,
		sum(quantity) as total_quantity,
		sum(sales_amount) as total_sales,
		sum(total_amount) as total_revenue,
		avg(Unit_price) as avg_price
from gold.fact_orders
group by DATE_FORMAT(order_date, '%Y-%m-01')
order by DATE_FORMAT(order_date, '%Y-%m-01')
)t;

/*-------------------------------------------------------------------------------------------------------------------------
 7) performamnce analysis: evaluate yearly performance of products 
-------------------------------------------------------------------------------------------------------------------------*/
-- yearly performance of products 
with yearly_product_sales as (
	select 
		year(o.order_date) as order_year,
		p.product_name,
		sum(o.sales_amount) as current_sales
	from gold.fact_orders o
	left join gold.dim_products p
	on o.product_key = p.product_key
	where o.order_date is not null
	group by 
	year(o.order_date),
	p.product_name
)
		select 
			order_year,
			product_name,
			current_sales,
			avg(current_sales) over(partition by product_name) as avg_sales,
			current_sales - avg(current_sales) over(partition by product_name) diff_avg,
			case when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'above avg'
				 when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'below avg'
			     else 'avg'
			end avg_change,
			 current_sales - lag(current_sales) over (partition by product_name order by order_year) diff_py,
			case when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'increase'
				 when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'decrease'
			     else 'no change'
			end py_change
		from yearly_product_sales
		order by order_year,
		product_name;

/*-------------------------------------------------------------------------------------------------------------------------
 8) proportional analysis: part to whole analysis of sales performance 
-------------------------------------------------------------------------------------------------------------------------*/
-- categories contribution to the overall sales
with category_sales as (
	select 
		category,
		sum(sales_amount) total_sales
	from gold.fact_orders o
	left join gold.dim_products p
	on p.product_key = o.product_key
	group by category
)
		select 
			category,
			total_sales,
			sum(total_sales) over() overall_sales,
			concat(round((cast(total_sales as float) / sum(total_sales) over()) * 100, 2), '%') as percentage_of_total
		from category_sales
		order by total_sales desc;

/*-------------------------------------------------------------------------------------------------------------------------
 9) data segmentation: segment product based on cost & product on their sales and order date
-------------------------------------------------------------------------------------------------------------------------*/
-- product segmentation by cost ranges 
with product_segment as (
	select 
		product_key,
		product_name,
		cost,
		case when cost < 50 then 'below 50'
			 when cost between 50 and 100 then '50-100'
			 when cost between 100 and 150 then '500-1000'
			 else 'above 150'
		end cost_range
	from gold.dim_products
)
		select 
			cost_range,
			count(product_key) as total_products
		from product_segment
		group by cost_range
		order by total_products desc;
		
/* group customers into three segments based on their spending behavioue:
	- VIP: customers with at least 5 months of history and spending more than $3,000
    - Regular: customers with at least 5 months of history but spendin $3,000 or less 
    - Now: customers with a lifespan less than 5 months.
and find the total number of customers by each group
*/
with customer_spending as
(
	select 
		customer_key,
		sum(sales_amount) as total_spending,
		min(order_date) as first_order,
		max(order_date) as last_order,
		timestampdiff(month, min(order_date), max(order_date)) as lifespan
	from gold.fact_orders
	group by customer_key 
)
		select
			customer_segment,
			count(customer_key) as total_customers
			from (
				select 
				customer_key,
				case when lifespan >= 4 and total_spending > 2000 then 'VIP'
					 when lifespan >= 4 and total_spending <= 2000 then 'Regular'
					 else 'New'
				end customer_segment
		from customer_spending) t
		group by customer_segment
		order by total_customers
