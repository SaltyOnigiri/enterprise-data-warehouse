# =====================================================
# Bronze Layer Ingestion
# =====================================================
# Purpose:
# Load raw CRM and ERP source files from Databricks
# Volumes into Bronze Delta tables.
#
# Process:
# 1. Read source CSV files
# 2. Infer schema using Spark
# 3. Add metadata columns for auditing and lineage
# 4. Create/overwrite Bronze Delta tables
# 5. Track total ingestion execution time
#
# Source Systems:
# - CRM (Customer Relationship Management)
# - ERP (Enterprise Resource Planning)
# =====================================================

import time
from pyspark.sql.functions import current_timestamp, lit

# Set working catalog and schema
spark.sql("USE CATALOG enterprise_dw")
spark.sql("USE SCHEMA bronze")

# Track total Bronze ingestion execution time
batch_start = time.time()

# Read CRM customer file
crm_cust = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv("/Volumes/enterprise_dw/bronze/source_files/source_crm/cust_info.csv")

    # Add metadata for data lineage and auditing
    .withColumn("source_system", lit("CRM"))
    .withColumn("ingestion_date", current_timestamp())
)

crm_prd = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv("/Volumes/enterprise_dw/bronze/source_files/source_crm/prd_info.csv")

    # Add metadata for data lineage and auditing
    .withColumn("source_system", lit("CRM"))
    .withColumn("ingestion_date", current_timestamp())
)

crm_sales = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv("/Volumes/enterprise_dw/bronze/source_files/source_crm/sales_details.csv")

    # Add metadata for data lineage and auditing
    .withColumn("source_system", lit("CRM"))
    .withColumn("ingestion_date", current_timestamp())
)

# Read ERP source files
erp_cust_az12 = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv("/Volumes/enterprise_dw/bronze/source_files/source_erp/CUST_AZ12.csv")

    # Add metadata for data lineage and auditing
    .withColumn("source_system", lit("ERP"))
    .withColumn("ingestion_date", current_timestamp())
)

erp_loc_a101 = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv("/Volumes/enterprise_dw/bronze/source_files/source_erp/LOC_A101.csv")

    # Add metadata for data lineage and auditing
    .withColumn("source_system", lit("ERP"))
    .withColumn("ingestion_date", current_timestamp())
)
    
erp_px_cat_g1v2 = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv("/Volumes/enterprise_dw/bronze/source_files/source_erp/PX_CAT_G1V2.csv")

    # Add metadata for data lineage and auditing
    .withColumn("source_system", lit("ERP"))
    .withColumn("ingestion_date", current_timestamp())
)

# Save as Bronze Delta tables
crm_cust.write \
    .mode("overwrite") \
    .format("delta") \
    .saveAsTable("crm_cust")

crm_prd.write \
    .mode("overwrite") \
    .format("delta") \
    .saveAsTable("crm_prd")

crm_sales.write \
    .mode("overwrite") \
    .format("delta") \
    .saveAsTable("crm_sales")

erp_cust_az12.write \
    .mode("overwrite") \
    .format("delta") \
    .saveAsTable("erp_cust_az12")

erp_loc_a101.write \
    .mode("overwrite") \
    .format("delta") \
    .saveAsTable("erp_loc_a101")

erp_px_cat_g1v2.write \
    .mode("overwrite") \
    .format("delta") \
    .saveAsTable("erp_px_cat_g1v2")
    
batch_end = time.time()
batch_duration = batch_end - batch_start

print(f"Bronze ingestion completed in {batch_duration:.2f} seconds")
