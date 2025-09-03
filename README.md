# sales-performance-analysis

**General Principles** 

•	**Naming Conventions**: Use snake_case, with lowercase letter and underscore (_) to separate words.

•	**Languages**: Use English for all names.

**Table Naming Conventions**

**Database Rules**

•	Table names must match their original source file name without renaming 

**Analysis Rules**

•	All names must use meaningful, business-aligned names for tables, starting with the category prefix.

•	<category> <entity>

  o	<category>: Describes the roles of the table, such as dim (dimension) or fact (fact table)
  
  o	<entity>: Descriptive name of the table, aligned with the business domain (e.g., customers, products)
  
  o	Example:
  
  	dim_products → Dimension table for products data

**Column Naming Conventions**

**Surrogate Keys**

•	All primary keys in dimension tables must use the suffix _key

•	<table_name_key>
  
  o	<table_name>: Refers to the name of the table or entity the key belongs to.
  
  o	_key: A suffix indicating that this column is a surrogate key.
  
  o	Example: customer_key → Surrogate key in the dim_customers table

**Technical Columns** 
•	All Technical columns must start with the prefix dwh_, followed by a descriptive name indicating the column’s purpose.
•	dwh_column_name
o	dwh: Prefix exclusively for system -generated metadata
o	<column_name>: Descriptive name indicating the column’s purpose.
o	Example: dwh_load_data: → System-generated column used to store the date when the record was loaded. 
Stored Procedure 
•	All stored procedures used for loading data must follow the naming pattern: load_<layer>
o	<layer>: Represents the layer being loaded

