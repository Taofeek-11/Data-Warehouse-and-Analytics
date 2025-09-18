/*
======================================================================================================
DDL Script: create brinze tables
=======================================================================================================
script purpose:
  this script creates tables in the 'bronze' schema, dropping existing tables if they already exists.
  run this script to re-define the DDL structure of 'bronze' tables
=======================================================================================================
*/
--creating tables
drop table if exists csv_customer;
create table bronze.csv_customer (
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
	preferred_category varchar(50)    
);

drop table if exists csv_products;
create table bronze.csv_products (
	product_id varchar (10) primary key,
	product_name varchar(100),
	category varchar(50),
	brand varchar(50),
	price decimal(10, 2),
	cost decimal(10, 2),
	launch_date datetime,
	current_inventory int,
	reorder_level int
);

drop table if exists csv_orders;
create table bronze.csv_orders(
order_id varchar(20) primary key,
customer_id varchar(20),
order_data Date,
order_status varchar(20),
subtotal int,
discount_amount float,
shipping_cost int,
tax_amount float,
payment_method varchar(20),
order_source varchar(20),
billing_country varchar(5),
constraint fk_customer foreign key (customer_id) references customer (customer_id)
 );

drop table if exists csv_order_items;
create table bronze.csv_order_items (
	order_item_id varchar (10) primary key,
	order_id varchar (10),
	product_id varchar (10),
	quantity int,
	unit_price decimal(10, 2),
	line_total int,
	constraint fk_orders foreign key (order_id) references csv_orders (order_id),
	constraint fk_products foreign key (product_id) references csv_products (product_id)
);


--inserting data into tables
delete from csv_customer;
load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\customers.csv'
into table csv_customer
fields terminated by ','
enclosed by '"'
lines terminated by '\n'; 

delete from csv_orders;
load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\orders.csv'
into table csv_orders
fields terminated by '.'
enclosed by '"'
lines terminated by '\n';

delete from csv_products;
load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\products.csv'
into table csv_products
fields terminated by ','
enclosed by '"'
lines terminated by '\n';

delete from csv_order_items;
load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\order_items.csv'
into table csv_order_items
fields terminated by ','
enclosed by '"'
lines terminated by '\n'

