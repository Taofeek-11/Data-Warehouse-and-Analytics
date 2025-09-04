/*
========================================================
create database and schemas
========================================================
script purpose:
	this script create a new database named 'data_warehouse' after checking if it already exists.
    if the databse exists, it is droped and recreated. additionally, the script sets up three schemas 
    within the database; 'bronze', 'silver', and 'gold'.
    
warning: 
	running this script will drop the entire 'data_warehouse' database if it exists.
    all data in the databse will be permanently deleted. proceed with caution and ensure you have proper 
    backups before running this script.*/  

-- drop and recreate 'data_warehouse' database 

DROP database IF EXISTS data_warehouse; 

-- create database "data_warehouse" 
Create database data_warehouse;
use data_warehouse;

-- create schemas 
Create Schema bronze;

Create Schema silver;

Create Schema gold;

Create Schema gold;
