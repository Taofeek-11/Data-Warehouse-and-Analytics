
/*
======================================================================================================
Stored procedure: load silver layer (source + silver)
=======================================================================================================
script purpose:
  this store procedure loads data into the 'bronze' schema from external csv files.
  it performs the following actions:
  - truncates the silver tables before loading data.
  - inserts transformed and cleaned data from bronze into silver table.

parameters:
  none.
this stored procedure does not accept any parameters or return any values.
=======================================================================================================
*/
DELIMITER //

CREATE PROCEDURE silver.load_procedure() 
BEGIN  
    SET @start_time = NOW();
    SET @batch_start_time = NOW();
    
    SELECT '====================================================' AS message;
    SELECT 'loading silver layer' AS message;
    SELECT '====================================================' AS message;
       
    SELECT '====================================================' AS message;
    SELECT 'loading csv table' AS message;
    SELECT '====================================================' AS message;
    
    -- loading silver.csv_customer
    SELECT '>> deleting table: silver.csv_customer' AS message;
    DELETE FROM silver.csv_customer;
    
    SELECT '>> inserting data into: silver.csv_customer' AS message;
    INSERT INTO silver.csv_customer (customer_id, email, first_name, last_name, registration_date, birth_year, gender, country, city, customer_segment, marketing_opt_in, preferred_category)
    SELECT 
        SUBSTRING(customer_id,6,5) AS customer_id,
        email,
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        registration_date,
        birth_year,
        CASE WHEN UPPER(TRIM(gender)) = 'F' THEN 'Female'
             WHEN UPPER(TRIM(gender)) = 'M' THEN 'Male'
             ELSE 'n/a'
        END AS gender,
        CASE WHEN UPPER(country) = 'CA' THEN 'Canada'
             WHEN UPPER(country) = 'UK' THEN 'United Kingdom'
             WHEN UPPER(country) = 'DE' THEN 'Germany'
             WHEN UPPER(country) = 'FR' THEN 'France'
             WHEN UPPER(country) = 'AU' THEN 'Australia'
             WHEN UPPER(country) = 'US' THEN 'United States'
             ELSE 'n/a'
        END AS country,
        city,
        customer_segment,
        marketing_opt_in,
        preferred_category
    FROM bronze.csv_customer;
    
    SET @end_time = NOW();
    SELECT CONCAT('>> load duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS message;
    SELECT '>>........' AS message;
    
    -- Reset start time for next operation
    SET @start_time = NOW();
    
    -- loading silver.csv_orders
    SELECT '>> deleting table: silver.csv_orders' AS message;
    DELETE FROM silver.csv_orders;
    
    SELECT '>> inserting data into: silver.csv_orders' AS message;
    INSERT INTO silver.csv_orders (order_id, customer_id, order_year, order_month, order_day, order_status, subtotal, discount_amount, shipping_cost, tax_amount, total_amount, payment_method, order_source, billing_country)
    SELECT 
        SUBSTRING(order_id,5,6) AS order_id,
        SUBSTRING(customer_id,6,5) AS customer_id,
        DATE_FORMAT(order_date,'%Y') AS order_year,
        DATE_FORMAT(order_date,'%b') AS order_month,
        DATE_FORMAT(order_date,'%d') AS order_day,
        order_status,
        subtotal,
        discount_amount,
        shipping_cost,
        tax_amount,
        total_amount,
        payment_method,
        order_source,
        CASE WHEN UPPER(billing_country) = 'CA' THEN 'Canada'
             WHEN UPPER(billing_country) = 'UK' THEN 'United Kingdom'
             WHEN UPPER(billing_country) = 'DE' THEN 'Germany'
             WHEN UPPER(billing_country) = 'FR' THEN 'France'
             WHEN UPPER(billing_country) = 'AU' THEN 'Australia'
             WHEN UPPER(billing_country) = 'US' THEN 'United States'
             ELSE 'n/a'
        END AS billing_country
    FROM bronze.csv_orders;
    
    SET @end_time = NOW();
    SELECT CONCAT('>> load duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS message;
    SELECT '>>........' AS message;
    
    -- Reset start time for next operation
    SET @start_time = NOW();
    
    -- loading silver.csv_order_items
    SELECT '>> deleting table: silver.csv_order_items' AS message;
    DELETE FROM silver.csv_order_items;
    
    SELECT '>> inserting data into: silver.csv_order_items' AS message;
    INSERT INTO silver.csv_order_items(order_item_id, order_id, product_id, quantity, unit_price, line_total)
    SELECT 
        order_item_id,
        SUBSTRING(order_id,5,6) AS order_id,
        SUBSTRING(product_id,6,4) AS product_id,
        quantity,
        unit_price,
        line_total
    FROM bronze.csv_order_items;
    
    SET @end_time = NOW();
    SELECT CONCAT('>> load duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS message;
    SELECT '>>........' AS message;
    
    -- Reset start time for next operation
    SET @start_time = NOW();
    
    -- loading silver.csv_products
    SELECT '>> deleting table: silver.csv_products' AS message;
    DELETE FROM silver.csv_products;
        
    SELECT '>> inserting into: silver.csv_products' AS message;
    INSERT INTO silver.csv_products (product_id, product_name, category, brand, price, cost, launch_year, launch_month, current_inventory, reorder_level)
    SELECT 
        SUBSTRING(product_id,6,4) AS product_id,
        TRIM(SUBSTRING_INDEX(product_name, ' ', -3)) AS product_name,
        category,
        brand,
        price,
        cost,
        DATE_FORMAT(launch_date,'%Y') AS launch_year,
        DATE_FORMAT(launch_date,'%b') AS launch_month,
        current_inventory,
        reorder_level
    FROM bronze.csv_products;
    
    SET @end_time = NOW();
    SELECT CONCAT('>> load duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS message;
    SELECT '>>........' AS message;
    
    -- Final summary
    SET @batch_end_time = NOW();
    SELECT CONCAT('>> Total batch duration: ', TIMESTAMPDIFF(SECOND, @batch_start_time, @batch_end_time), ' seconds') AS final_message;
    
END //

DELIMITER ;
