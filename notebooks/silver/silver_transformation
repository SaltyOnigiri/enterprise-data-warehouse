# =====================================================
# Silver Layer Transformations
# =====================================================
# Purpose:
# Clean, standardize, and validate Bronze data before
# loading it into curated Silver Delta tables.
#
# Process:
# 1. Read Bronze Delta tables
# 2. Apply data quality and business rule transformations
# 3. Standardize formats and handle invalid values
# 4. Create curated Silver Delta tables
#
# Source Systems:
# - CRM (Customer Relationship Management)
# - ERP (Enterprise Resource Planning)
# =====================================================

from pyspark.sql.window import Window
from pyspark.sql.functions import (
    row_number, desc, trim, when, col,
    substring, regexp_replace, length, to_date, current_date
)

# Set working catalog and schema
spark.sql("USE CATALOG enterprise_dw")
spark.sql("USE SCHEMA silver")

# Read CRM Tables
crm_cust = spark.table("enterprise_dw.bronze.crm_cust")
crm_prd = spark.table("enterprise_dw.bronze.crm_prd")
crm_sales = spark.table("enterprise_dw.bronze.crm_sales")

# Read ERP Tables
erp_cust_az12 = spark.table("enterprise_dw.bronze.erp_cust_az12")
erp_loc_a101 = spark.table("enterprise_dw.bronze.erp_loc_a101")
erp_px_cat_g1v2 = spark.table("enterprise_dw.bronze.erp_px_cat_g1v2")

# -----------------------------
# CRM Customer Transformations
# -----------------------------

# Define a window to identify the most recent record for each customer.
customer_window = Window.partitionBy("cst_key").orderBy(desc("cst_create_date"))

# Keep only the latest version of each customer record.
crm_cust_clean = (
    crm_cust
    .withColumn("row_num", row_number().over(customer_window))
    .filter("row_num = 1")
    .drop("row_num")
)

# Remove records with missing customer IDs.
crm_cust_clean = crm_cust_clean.filter(crm_cust_clean.cst_id.isNotNull())

# Standardize customer names by removing leading and trailing whitespace.
crm_cust_clean = (
    crm_cust_clean
    .withColumn("cst_firstname", trim(crm_cust_clean.cst_firstname))
    .withColumn("cst_lastname", trim(crm_cust_clean.cst_lastname))
)

# Replace abbreviated marital status codes with descriptive values.
crm_cust_clean = crm_cust_clean.withColumn(
    "cst_marital_status",
    when(trim(col("cst_marital_status")) == "S", "Single")
    .when(trim(col("cst_marital_status")) == "M", "Married")
    .otherwise(col("cst_marital_status"))
)

# Replace abbreviated gender codes with descriptive values.
crm_cust_clean = crm_cust_clean.withColumn(
    "cst_gndr",
    when(trim(col("cst_gndr")) == "M", "Male")
    .when(trim(col("cst_gndr")) == "F", "Female")
    .otherwise(col("cst_gndr"))
)

# -----------------------------
# CRM Product Transformations
# -----------------------------

# Copy the first 5 characters from prd_key, swap - for _, and create new column cat_id.
# Offset 7 characters and copy full length, swap - for _, and create a new column sls_prd_key.
crm_prd_clean = (
    crm_prd
    .withColumn("cat_id", regexp_replace(substring("prd_key", 1, 5), "-", "_"))
    .withColumn("sls_prd_key", regexp_replace(substring("prd_key", 7, length("prd_key")), "-", "_"))
)

# Turn NULL values to 0 for prd_cost
crm_prd_clean = (
    crm_prd_clean
    .withColumn("prd_cost", when(col("prd_cost").isNull(), 0).otherwise(col("prd_cost")))

)

# Replace abbreviated line status codes with descriptive values.
crm_prd_clean = crm_prd_clean.withColumn(
    "prd_line",
    when(trim(col("prd_line")) == "R", "Road")
    .when(trim(col("prd_line")) == "S", "Other Sales")
    .when(trim(col("prd_line")) == "M", "Mountain")
    .when(trim(col("prd_line")) == "T", "Touring")
    .otherwise(col("prd_line"))
)

# Flag invalid date ranges
crm_prd_clean = crm_prd_clean.withColumn(
    "missing_start_date",
    col("prd_start_dt").isNull() & col("prd_end_dt").isNotNull()
).withColumn(
    "invalid_date_range",
    col("prd_start_dt").isNotNull() & col("prd_end_dt").isNotNull() & (col("prd_start_dt") > col("prd_end_dt"))
)

# -----------------------------
# CRM Sales Details Transformations
# -----------------------------

# Flag order dates that are not in the expected YYYYMMDD format.
crm_sales_clean = crm_sales.withColumn(
    "invalid_order_date",
    length(col("sls_order_dt").cast("string")) != 8
)

# Convert valid order dates to Spark date type.
# Invalid values are set to null for downstream handling.
crm_sales_clean = crm_sales_clean.withColumn(
    "sls_order_dt",
    when(col("invalid_order_date"), None)
    .otherwise(to_date(col("sls_order_dt").cast("string"), "yyyyMMdd"))
)

# Convert ship date from YYYYMMDD to Spark date type.
crm_sales_clean = crm_sales_clean.withColumn(
    "sls_ship_dt",
    to_date(col("sls_ship_dt").cast("string"), "yyyyMMdd")
)

crm_sales_clean = crm_sales_clean.withColumn(
    "sls_due_dt",
    to_date(col("sls_due_dt").cast("string"), "yyyyMMdd")
)

# Flag invalid financial values for downstream review.
crm_sales_clean = (
    crm_sales_clean
    .withColumn("invalid_sales_amount", col("sls_sales").isNull() | (col("sls_sales") <= 0))
    .withColumn("invalid_quantity", col("sls_quantity").isNull() | (col("sls_quantity") <= 0))
    .withColumn("invalid_price", col("sls_price").isNull() | (col("sls_price") <= 0))
)

# Populate missing sales only when quantity and price are valid.
crm_sales_clean = crm_sales_clean.withColumn(
    "sls_sales",
    when(
        col("sls_sales").isNull()
        & col("sls_quantity").isNotNull()
        & (col("sls_quantity") > 0)
        & col("sls_price").isNotNull()
        & (col("sls_price") > 0),
        col("sls_quantity") * col("sls_price")
    ).otherwise(col("sls_sales"))
)

# Populate missing price only when sales and quantity are valid.
crm_sales_clean = crm_sales_clean.withColumn(
    "sls_price",
    when(
        col("sls_price").isNull()
        & col("sls_sales").isNotNull()
        & (col("sls_sales") > 0)
        & col("sls_quantity").isNotNull()
        & (col("sls_quantity") > 0),
        col("sls_sales") / col("sls_quantity")
    ).otherwise(col("sls_price"))
)

# -----------------------------
# ERP Birthdate Transformations
# -----------------------------

# Remove first three characters from CID.
erp_cust_clean = (
    erp_cust_az12
    .withColumn("CID", substring("CID", 4, 10))
)

# Validate birth dates and null invalid values.
erp_cust_clean = (
    erp_cust_clean
    .withColumn(
        "invalid_birth_date",
        (col("bdate") < "1924-01-01") |
        (col("bdate") > current_date())
    )
    .withColumn(
        "bdate",
        when(col("invalid_birth_date"), None)
        .otherwise(col("bdate"))
    )
)

erp_cust_clean = erp_cust_clean.withColumn(
    "GEN",
    when(trim(col("GEN")) == "", None)
    .when(trim(col("GEN")) == "M", "Male")
    .when(trim(col("GEN")) == "F", "Female")
    .otherwise(col("GEN"))
)

# -----------------------------
# ERP Location Transformations
# -----------------------------

erp_loc_clean = (
    erp_loc_a101
    .withColumn("CID", regexp_replace("CID", "-", ""))
)

erp_loc_clean = erp_loc_clean.withColumn(
    "CNTRY",
    when(trim(col("CNTRY")) == "", None)
    .when(trim(col("CNTRY")) == "USA", "United States")
    .when(trim(col("CNTRY")) == "US", "United States")
    .when(trim(col("CNTRY")) == "DE", "Delaware")
    .otherwise(col("CNTRY"))
)

# -----------------------------
# ERP Product Transformations
# -----------------------------
# Did not require cleaning. Renamed for Silver layer naming convention.
erp_px_cat_clean = erp_px_cat_g1v2

# Save as Silver Delta Tables
crm_cust_clean.write \
    .mode("overwrite") \
    .saveAsTable("enterprise_dw.silver.crm_cust")

crm_prd_clean.write \
    .mode("overwrite") \
    .saveAsTable("enterprise_dw.silver.crm_prd")

crm_sales_clean.write \
    .mode("overwrite") \
    .saveAsTable("enterprise_dw.silver.crm_sales")

erp_cust_clean.write \
    .mode("overwrite") \
    .saveAsTable("enterprise_dw.silver.erp_cust")

erp_loc_clean.write \
    .mode("overwrite") \
    .saveAsTable("enterprise_dw.silver.erp_loc")

erp_px_cat_clean.write \
    .mode("overwrite") \
    .saveAsTable("enterprise_dw.silver.erp_px_cat")
