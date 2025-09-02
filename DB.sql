-- Active: 1756445168036@@localhost@3306
drop table if exists customer;
drop table if exists orders;
drop table if exists order_items;
drop table if exists products;

create database Shopping_DB;

-- creating tables----
create table customer (
    customer_id varchar (10) primary key,
    email varchar(100) UNIQUE,
    first_name varchar(50),
    last_name varchar(50),
    registration_date datetime,
    birth_year int,
    gender varchar(10),
    country varchar(50),
    city varchar(50),
    customer_segment varchar(20),
    marketing_opt_in boolean,
    preferred_category varchar(50)    
);

create table products (
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

create table orders (
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
    constraint fk_customer foreign key (customer_id) references customer (customer_id)
);

create table order_items (
    order_item_id varchar (10) primary key,
    order_id varchar (10),
    product_id varchar (10),
    quantity int,
    unit_price decimal(10, 2),
    line_total int,
    constraint fk_orders foreign key (order_id) references orders (order_id),
    constraint fk_products foreign key (product_id) references products (product_id)
);
  
 -- inserting values into tables ---
LOAD DATA LOCAL INFILE 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

LOAD DATA LOCAL INFILE 'C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\customers.csv'
INTO TABLE customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\order_items.csv"
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "C:\\Users\\USER\\Documents\\SQLProject\\E-commerce\\CSV_File\\products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
