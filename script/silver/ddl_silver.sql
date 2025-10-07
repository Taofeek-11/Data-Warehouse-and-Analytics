/*
======================================================================================================
DDL Script: create silver tables
=======================================================================================================
script purpose:
  this script creates tables in the 'silver' schema, dropping existing tables if they already exists.
  run this script to re-define the DDL structure of 'silver' tables
=======================================================================================================
*/
-- creating tables
drop table if exists silver.csv_customer;
create table silver.csv_customer (
	customer_id varchar (10) primary key,
	email varchar(100) UNIQUE,
	first_name varchar(50),
	last_name varchar(50),
	registration_date datetime,
	birth_year int,
	gender varchar(10),
	country varchar(50),
	city varchar(50),
	customer_segment varchar(50),
	marketing_opt_in boolean,
	preferred_category varchar(50),
    dwh_create_date datetime default NOW()
    );

drop table if exists csv_products;
create table silver.csv_products (
	product_id varchar (10) primary key,
	product_name varchar(100),
	category varchar(50),
	brand varchar(50),
	price decimal(10, 2),
	cost decimal(10, 2),
	launch_year int,
    launch_month varchar (10),
	current_inventory int,
	reorder_level int,   
    dwh_create_date datetime default NOW()
);

drop table if exists silver.csv_orders;
create table silver.csv_orders(
order_id varchar(20) primary key,
customer_id varchar(20),
order_date date,
order_status varchar(20),
subtotal int,
discount_amount float,
shipping_cost int,
tax_amount float,
total_amount decimal (10,2),
payment_method varchar(20),
order_source varchar(20),
billing_country varchar(20),
constraint fk_customer foreign key (customer_id) references customer (customer_id),
dwh_create_date datetime default NOW()
 );

drop table if exists csv_order_items;
create table silver.csv_order_items (
	order_item_id varchar (10) primary key,
	order_id varchar (10),
	product_id varchar (10),
	quantity int,
	unit_price decimal(10, 2),
	line_total int,
	constraint fk_orders foreign key (order_id) references csv_orders (order_id),
	constraint fk_products foreign key (product_id) references csv_products (product_id),
    dwh_create_date datetime default NOW()
   );


