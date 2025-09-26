/*
=============================================================================
quality checks
=============================================================================
script purpose:
  this script performs various quality checks for data consistency, accuracy,
  and standardization across the 'silver' schemas: it include checks for:
  - null or duplicate primary keys,
  - unwanted spaces in string fields.
  - data standardization and consistency.
  - data consistency between related fields.

usage notes;
  - run these checks after data loading silver layer.
  - investigate and resolve any discrepancies found during the checks 
=============================================================================
*/

-- ===========================================================
-- checking 'silver.csv_customers'
-- ===========================================================
-- check for nulls or duplicates in primary key
-- expectation: no result
select 

-- check for unwanted spaces
-- expectation: no results

-- data standardization & consistency 

-- check for invalid date orders

-- check data consistency: between ....
-- >>sales ....
-- >> values must not be null, zero, or negative.

-- conditions 

