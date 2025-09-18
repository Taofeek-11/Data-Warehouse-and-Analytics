/*
======================================================================================================
DDL Script: create brinze tables
=======================================================================================================
script purpose:
  this script creates tables in the 'bronze' schema, dropping existing tables if they already exists.
  run this script to re-define the DDL structure of 'bronze' tables
=======================================================================================================
*/
use data_warehouse;
-- creating tables
drop table if exists bronze.csv_customer;
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
	marketing_opt_in bit,
	preferred_category varchar(50)    
);

drop table if exists bronze.csv_products;
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

drop table if exists bronze.csv_orders;
create table bronze.csv_orders (
	order_id varchar (20) primary key,
	customer_id varchar (20),
	order_date date,
	order_status varchar(50),
	subtotal int,
	discount_amount decimal (10, 2),
	shipping_cost int,
    tax_amount decimal (10, 2),
	total_amount decimal (10, 2),
	payment_method varchar(50),
	order_source varchar(50),
	billing_country varchar(5),
	constraint fk_cvs_customer foreign key (customer_id) references bronze.csv_customer (customer_id)
);

drop table if exists bronze.csv_order_items;
create table bronze.csv_order_items (
	order_item_id varchar (10) primary key,
	order_id varchar (10),
	product_id varchar (10),
	quantity int,
	unit_price decimal(10, 2),
	line_total int,
	constraint fk_orders foreign key (order_id) references bronze.csv_orders (order_id),
	constraint fk_products foreign key (product_id) references bronze.csv_products (product_id)
);

-- inserting data into tables
delete from csv_customer;
load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\customers.csv'
into table csv_customer
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
IGNORE 1 ROWS;  

delete from csv_orders;
LOAD DATA LOCAL INFILE 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\orders.csv' 
INTO TABLE csv_orders 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(order_id, customer_id, order_date, order_status, subtotal, discount_amount, shipping_cost, total_amount, tax_amount, payment_method, order_source, billing_country);

delete from csv_products;
load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\products.csv'
into table csv_products
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

delete from csv_order_items;
load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\order_items.csv'
into table csv_order_items
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
IGNORE 1 ROWS; 
