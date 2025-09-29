# Data Warehouse and Analytics
----

Welcome to the **Data Warehouse and Analytics** repository.
This project demostrates data warehousing and analytics of an e-commerce store.  It builds an effective warehouse for data effectiveness and data analytics for actionable insights.

---

## Project Requirement 

## Building the Data warehouse (Data Engineering)

#### Objectives 
Develop a warehouse using SQL Server to consolidate the e-commerce store data, enabling analytical reporting and data-driven decision-making.

#### Specifications
•	**Data Sources**: Import data from data warehouse provided as CSV files.

•	**Data Quality**: Cleanse and resolve data quality issues prior to analysis

•	**Integration**: Integrate data into a single, user-friendly data model designed for analytical queries.

•	**Scope**: focus on the latest dataset only.

•	**Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analytics)

### Objectives 
Develop SQL-based analytics for actionable insights into:

•	**Product Performance**

•	**Cus•	**Marketing Perfomance**
tomer Behaviour**

•	**Customer Values**

•	**Sales Trends**


These insights empower stakeholders with business metrics for strategic decision-making.

---

## Data Architecture

This project adopts the medallion architecture: Bronze, Silver, and Gold layer.

![Data Architecture](doc./data_architecture.png)

1. **Bronze:** Stores raw data without changes from source systems. Data from CSV files are ingested into a SQL server for analysis
2. **Silver:** Data were cleaned, standardized, and normalized for analysis.
3. **Gold:** Stores business-ready data modelled for a star schema for analysis and reporting.    

---

## Responsitory Structure

project-name/
├── datasets/ # Raw datasets used for the project
│ ├── customers.csv # Customer data
│ ├── order_items.csv # Order item-level details
│ ├── orders.csv # Order-level data
│ └── products.csv # Product details
│
├── docs/ # Documentation and architecture
│ ├── Data_dictionary.pdf # Data dictionary
│ ├── data_model.png # Star schema model
│ └── data_flow.png # Data flow diagram
│
├── scripts/ # SQL scripts for ETL
│ ├── bronze/ # Raw data extraction
│ ├── silver/ # Data cleaning
│ └── gold/ # Analytical layer
│
└── README.md # Project overview



---
## Licence

This project is licenced under the (MIT Licence) LICENSE. You are free to use, modify, and share this project with proper attribution

## About Me

Hi, I'm oladigbolu taofeek...


