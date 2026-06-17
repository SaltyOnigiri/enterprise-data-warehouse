# Bronze Layer Ingestion

## Purpose

The Bronze layer ingests raw CRM and ERP source files into Delta tables while preserving the original source data.

## Process

- Read source CSV files from Databricks Volumes
- Infer schemas automatically using Spark
- Add ingestion metadata (`source_system` and `ingestion_date`)
- Write data to Bronze Delta tables using overwrite mode

## Output Tables

- `crm_cust`
- `crm_prd`
- `crm_sales`
- `erp_cust_az12`
- `erp_loc_a101`
- `erp_px_cat_g1v2`
