/*
======================================================================================================
Stored procedure: load bronze layer (source + bronze)
=======================================================================================================
script purpose:
  this store procedure loads data into the 'bronze' schema from external csv files.
  it performs the following actions:
  - truncates the bronze tables before loading data.
  - uses the 'load data local infile' command to load data from csv files to bronze tables.

parameters:
  none.
this stored procedure does not accept any parameters or return any values.
=======================================================================================================
*/
create procedure bronze.load_bronze ()
begin
	select 'Creating csv_customer table...' as msg;
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

	select 'Creating csv_products table...' as msg;
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

	select 'Creating csv_orders table...' as msg;
    drop table if exists csv_orders;
	create table bronze.csv_orders (
		order_id varchar (10) primary key,
		customer_id varchar (10),
		order_date datetime,
		order_status varchar(50),
		subtotal int(10),
		discount_amount decimal (10, 2),
		shipping_cost decimal (10, 2),
		total_amount decimal (10, 2),
		tax_amount decimal (10, 2),
		payment_method varchar(50),
		order_source varchar(50),
		billing_country varchar(50),
		constraint fk_customer foreign key (customer_id) references csv_customer (customer_id)
	);

select 'Creating csv_order_items... as msg';
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
End
//
DELIMITER ;

	select 'Inserting data into: bronze.csv_customer' as msg;
	delete from csv_customer;
	load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\customers.csv'
	into table csv_customer
	fields terminated by ','
	enclosed by '"'
	lines terminated by '\n'; 

	select 'Inserting data into: bronze.csv_orders' as msg;
	delete from csv_orders;
	load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\orders.csv'
	into table csv_orders
	fields terminated by '.'
	enclosed by '"'
	lines terminated by '\n';

	select 'Inserting data into: bronze.csv_products' as msg;
	delete from csv_products;
	load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\products.csv'
	into table csv_products
	fields terminated by ','
	enclosed by '"'
	lines terminated by '\n';
    

	select 'Inserting data into: bronze.csv_order_items' as msg;
    delete from csv_order_items;
    load data local infile 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\order_items.csv'
    into table csv_order_items
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
    
