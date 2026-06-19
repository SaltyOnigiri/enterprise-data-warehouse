# Business Requirements

## Project Overview

The organization stores customer, product, sales, and reference data across separate CRM and ERP systems. This fragmentation makes reporting difficult and increases the risk of inconsistent business metrics.

This project addresses those challenges by building a centralized enterprise data warehouse in Databricks using a Medallion Architecture. Raw operational data is ingested, cleansed, validated, and transformed into analytics-ready dimensional models.

## Project Objectives

- Integrate CRM and ERP data into a centralized warehouse
- Improve data quality through cleansing, validation, and standardization
- Preserve transparency by flagging invalid data during transformation
- Build analytics-ready dimension and fact tables using a star schema
- Provide clear documentation and reproducible ETL pipelines

## Business Goals

### Data Integration

Consolidate customer, product, sales, and reference data from multiple source systems into a single analytical platform.

### Data Quality

Apply business rules to standardize values, validate records, and improve consistency across datasets.

Examples include:
- Duplicate customer removal
- Product date range validation
- Sales value validation and recalculation where appropriate
- Birth date validation
- Standardized gender, marital status, and country values
- Product key standardization for cross-system joins

### Analytics Enablement

Deliver business-ready dimension and fact tables optimized for reporting, dashboarding, and ad hoc SQL analysis.

### Maintainability

Use a layered Bronze → Silver → Gold architecture that clearly separates raw ingestion, transformation logic, and analytical models.

## Scope

### Included

- CRM and ERP data ingestion
- Bronze layer raw data storage
- Silver layer cleansing, validation, and standardization
- Business rule enforcement and derived columns
- Gold layer star schema with dimension and fact tables
- Surrogate key generation and dimensional joins
- Architecture diagrams and technical documentation

## Success Criteria

- Source data is successfully ingested into Bronze tables
- Business rules and validations are applied in the Silver layer
- Gold layer provides consistent customer, product, and sales models
- Fact and dimension tables are linked through surrogate keys
- Invalid records are appropriately flagged or excluded from analytical models
- Documentation accurately describes the architecture and implementation

## Expected Outcomes

Upon completion, the solution provides:

- A centralized enterprise data warehouse built in Databricks
- A Medallion Architecture consisting of Bronze, Silver, and Gold layers
- Cleaned and standardized Silver datasets
- A star schema with customer and product dimensions linked to a sales fact table
- Built-in data quality validation and business rule enforcement
- Analytics-ready data suitable for reporting and business intelligence
- A maintainable foundation for future expansion
