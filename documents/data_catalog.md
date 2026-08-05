# Data Catalog for Gold Layer

## Overview

The Gold Layer represents the business-ready data model designed to support reporting, business intelligence, and analytical workloads. It is organized into **dimension tables** and **fact tables** that capture key business entities and measurable business transactions.

---

### 1. **gold.dim_customers**

* **Purpose:** Contains customer information enriched with demographic and geographic attributes.
* **Columns:**

| Column Name     | Data Type    | Description                                                                         |
| --------------- | ------------ | ----------------------------------------------------------------------------------- |
| customer_key    | INT          | Surrogate key that uniquely identifies each customer record in the dimension table. |
| customer_id     | INT          | Unique identifier assigned to each customer.                                        |
| customer_number | NVARCHAR(50) | Alphanumeric customer reference used for identification and tracking.               |
| first_name      | NVARCHAR(50) | Customer's given name as stored in the source system.                               |
| last_name       | NVARCHAR(50) | Customer's family or surname.                                                       |
| country         | NVARCHAR(50) | Country where the customer resides (e.g., 'Australia').                             |
| marital_status  | NVARCHAR(50) | Customer's marital status (e.g., 'Married', 'Single').                              |
| gender          | NVARCHAR(50) | Customer's gender (e.g., 'Male', 'Female', 'n/a').                                  |
| birthdate       | DATE         | Customer's date of birth in YYYY-MM-DD format (e.g., 1971-10-06).                   |
| create_date     | DATE         | Date when the customer record was created in the system.                            |

---

### 2. **gold.dim_products**

* **Purpose:** Stores product information along with its descriptive attributes.
* **Columns:**

| Column Name          | Data Type    | Description                                                                        |
| -------------------- | ------------ | ---------------------------------------------------------------------------------- |
| product_key          | INT          | Surrogate key that uniquely identifies each product record in the dimension table. |
| product_id           | INT          | Unique identifier assigned to each product.                                        |
| product_number       | NVARCHAR(50) | Alphanumeric product code used for identification and inventory management.        |
| product_name         | NVARCHAR(50) | Descriptive product name including details such as type, color, and size.          |
| category_id          | NVARCHAR(50) | Unique identifier representing the product category.                               |
| category             | NVARCHAR(50) | High-level product classification (e.g., Bikes, Components).                       |
| subcategory          | NVARCHAR(50) | More specific grouping of the product within its category.                         |
| maintenance_required | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').            |
| cost                 | INT          | Base cost of the product expressed in whole currency units.                        |
| product_line         | NVARCHAR(50) | Product series or line to which the item belongs (e.g., Road, Mountain).           |
| start_date           | DATE         | Date when the product became available for sale or use.                            |

---

### 3. **gold.fact_sales**

* **Purpose:** Stores sales transaction records for reporting and business analysis.
* **Columns:**

| Column Name   | Data Type    | Description                                                                        |
| ------------- | ------------ | ---------------------------------------------------------------------------------- |
| order_number  | NVARCHAR(50) | Unique alphanumeric identifier assigned to each sales order (e.g., 'SO54496').     |
| product_key   | INT          | Surrogate key that links the sales record to the product dimension.                |
| customer_key  | INT          | Surrogate key that links the sales record to the customer dimension.               |
| order_date    | DATE         | Date on which the customer placed the order.                                       |
| shipping_date | DATE         | Date on which the order was shipped.                                               |
| due_date      | DATE         | Payment due date associated with the order.                                        |
| sales_amount  | INT          | Total sales value of the transaction line item, expressed in whole currency units. |
| quantity      | INT          | Number of product units included in the transaction.                               |
| price         | INT          | Unit selling price of the product in whole currency units.                         |
