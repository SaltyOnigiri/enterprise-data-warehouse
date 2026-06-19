# Gold Layer Transformations

## Purpose

The Gold layer transforms curated Silver datasets into analytics-ready dimension and fact tables using a star schema. These tables are designed for reporting, business intelligence, and ad hoc analysis.

## Dimension Tables

### Customer Dimension (`dim_customer`)

- Generated a surrogate key (`customer_key`).
- Combined CRM customer data with ERP demographic and location data.
- Prioritized CRM gender values when available.
- Standardized customer attributes into a single analytical model.

### Product Dimension (`dim_product`)

- Generated a surrogate key (`product_key`).
- Combined product information with ERP category data.
- Excluded records with invalid date ranges or missing start dates.
- Created a business-friendly product dimension for reporting.

## Fact Table

### Sales Fact (`fact_sales`)

- Joined sales transactions to customer and product dimensions.
- Replaced business identifiers with surrogate keys (`customer_key` and `product_key`).
- Excluded records with unresolved data quality issues.
- Included core business measures:
  - `sales`
  - `quantity`
  - `price`
- Included key transaction dates:
  - `order_date`
  - `ship_date`
  - `due_date`

## Data Model

The Gold layer follows a star schema consisting of:
- `dim_customer`
- `dim_product`
- `fact_sales`

![Architecture Diagram](diagrams/gold_star_schema.png)


