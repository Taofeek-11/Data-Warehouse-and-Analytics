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
	
	select 'Creating csv_products table...' as msg;
	
	select 'Creating csv_orders table...' as msg;
    
	select 'Creating csv_order_items...' as msg;

	select 'Inserting data into: bronze.csv_customer' as msg;

	select 'Inserting data into: bronze.csv_orders' as msg;
	
	select 'Inserting data into: bronze.csv_products' as msg;
	
	select 'Inserting data into: bronze.csv_order_items' as msg;
End
//
DELIMITER ;


