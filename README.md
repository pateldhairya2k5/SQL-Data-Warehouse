# SQL-Data-Warehouse

Welcome to the repository! 



This project presents a complete data warehousing and analytics solution, covering everything from data ingestion and transformation to dimensional modeling and business reporting. Developed as a portfolio project, it demonstrates practical data engineering techniques and industry best practices for building analytical data platforms.



## Data Architecture 



The project adopts the **Medallion Architecture**, organizing data into three logical layers: **Bronze**, **Silver**, and **Gold**.



> **Architecture Diagram**

<img width="1441" height="621" alt="Screenshot 2026-08-05 172645" src="https://github.com/user-attachments/assets/7a2a8a7d-4f26-456b-955e-9e3a3002c31d" />

### Bronze Layer



* Serves as the landing zone for raw data extracted from the source systems.

* Imports ERP and CRM data from CSV files into the database.

* Retains the original source data without applying transformations.



### Silver Layer



* Processes and refines the raw data through cleansing and standardization.

* Resolves data quality issues, removes duplicates, and applies business rules.

* Produces consistent and reliable datasets for downstream analytics.



### Gold Layer



* Stores business-ready data organized using a Star Schema.

* Contains dimension and fact tables optimized for reporting and analytical queries.

* Acts as the primary source for dashboards, KPIs, and business intelligence.



## 📖 Project Overview



This project includes the following components:



* Designing a modern data warehouse using the Medallion Architecture.

* Developing ETL pipelines to extract, transform, and load data.

* Building dimension and fact tables for analytical workloads.

* Creating a business-oriented data model to support reporting.

* Generating SQL-based reports that provide meaningful business insights.



## 🎯 Skills Demonstrated



This repository showcases practical experience in:



* SQL Development

* PostgreSQL

* Data Warehousing

* Data Engineering

* ETL Pipeline Development

* Data Modeling

* Business Intelligence

* Data Analytics



## 🛠️ Tools & Technologies



All tools used in this project are freely available.



* PostgreSQL

* pgAdmin

* Draw.io

* Git & GitHub

* CSV Files



## 🚀 Project Requirements



### Building the Data Warehouse (Data Engineering)



#### Objective



Develop a modern data warehouse that consolidates ERP and CRM sales data into a centralized repository for analytical reporting and business decision-making.



#### Specifications



* Import ERP and CRM data from CSV files.

* Clean and validate data before loading it into analytical models.

* Integrate multiple source systems into a unified warehouse.

* Design a data model optimized for reporting and analysis.

* Document the warehouse structure and data model for technical and business users.



### Business Analytics & Reporting



#### Objective



Develop SQL-based analytical solutions that deliver valuable business insights in the following areas:



* Customer Behavior

* Product Performance

* Sales Trends



These analyses provide stakeholders with meaningful metrics to support informed business decisions.



For additional information, refer to **docs/requirements.md**.



## 📂 Repository Structure



```text

data-warehouse-project/

│

├── datasets/                           # ERP and CRM source datasets

│

├── docs/                               # Project documentation

│   ├── etl.drawio                      # ETL workflow diagrams

│   ├── data_architecture.drawio        # Data warehouse architecture

│   ├── data_catalog.md                 # Data dictionary and metadata

│   ├── data_flow.drawio                # Data flow diagrams

│   ├── data_models.drawio              # Star schema design

│   ├── naming_conventions.md           # Naming standards

│

├── scripts/                            # SQL scripts

│   ├── bronze/                         # Raw data ingestion

│   ├── silver/                         # Data cleansing and transformation

│   ├── gold/                           # Analytical model creation

│

├── tests/                              # Data validation scripts

│

├── README.md

├── LICENSE

├── .gitignore

└── requirements.txt

```
