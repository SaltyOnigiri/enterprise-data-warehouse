# Bronze Layer Ingestion

## Purpose

The Bronze layer ingests raw CRM and ERP source files into Delta tables with minimal transformation, preserving the original data for traceability, auditing, and downstream processing.

## Process

1. Read source CSV files from Databricks Volumes
2. Automatically infer schemas using Apache Spark
3. Add ingestion metadata (`source_system` and `ingestion_date`)
4. Load the data into Bronze Delta tables using overwrite mode

## Output Tables

- `crm_cust`
- `crm_prd`
- `crm_sales`
- `erp_cust_az12`
- `erp_loc_a101`
- `erp_px_cat_g1v2`

## Key Characteristics

- Raw source data is preserved
- Minimal transformations are applied
- Ingestion metadata is captured for lineage and auditing
- Serves as the foundation for Silver layer data cleansing and validation
