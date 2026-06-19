-- =====================================================
-- Gold Layer Transformations
-- =====================================================
-- Purpose:
-- Create analytics-ready dimension and fact tables
-- using cleaned Silver layer data.
--
-- Process:
-- 1. Build customer dimension
-- 2. Build product dimension
-- 3. Build sales fact table
-- 4. Exclude records with unresolved data quality issues
--
-- The Gold layer is optimized for reporting and
-- business intelligence workloads.
-- =====================================================

USE CATALOG enterprise_dw;
USE SCHEMA silver;

-- =====================================================
-- Customer Dimension
-- =====================================================
-- Combines CRM customer data with ERP demographic
-- and location information to create a unified
-- customer dimension.

CREATE OR REPLACE TABLE gold.dim_customer AS
SELECT
    -- Generate surrogate key for dimensional model.
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,

    -- Business identifiers.
    c.cst_id AS customer_id,
    c.cst_key AS customer_number,

    -- Customer attributes.
    c.cst_firstname AS first_name,
    c.cst_lastname AS last_name,
    l.CNTRY AS country,
    c.cst_marital_status AS marital_status,

    -- CRM is treated as the authoritative source for gender.
    CASE
        WHEN c.cst_gndr IS NOT NULL THEN c.cst_gndr
        WHEN e.GEN IS NOT NULL THEN e.GEN
        ELSE NULL
    END AS gender,

    e.bdate AS birth_date,
    c.cst_create_date AS creation_date

FROM crm_cust c
LEFT JOIN erp_cust e
    ON c.cst_key = e.CID
LEFT JOIN erp_loc l
    ON c.cst_key = l.CID;


-- =====================================================
-- Product Dimension
-- =====================================================
-- Enriches CRM product records with ERP category
-- information and excludes products with invalid
-- date relationships.

CREATE OR REPLACE TABLE gold.dim_product AS
SELECT
    -- Generate surrogate key for dimensional model.
    ROW_NUMBER() OVER (ORDER BY p.prd_id) AS product_key,

    -- Business identifiers.
    p.prd_id AS product_id,
    p.sls_prd_key AS product_number,

    -- Product attributes.
    p.prd_nm AS product_name,
    p.cat_id AS category_id,
    c.CAT AS category,
    c.SUBCAT AS sub_category,
    c.MAINTENANCE AS maintenance,
    p.prd_cost AS product_cost,
    p.prd_line AS product_line,
    p.prd_start_dt AS start_date,
    p.prd_end_dt AS end_date

FROM crm_prd p
LEFT JOIN erp_px_cat c
    ON p.cat_id = c.ID

-- Remove products with unresolved date issues.
WHERE p.invalid_date_range = FALSE
  AND p.missing_start_date = FALSE;


-- =====================================================
-- Sales Fact Table
-- =====================================================
-- Creates the central fact table by
-- linking sales records to customer and product
-- dimensions using surrogate keys.

CREATE OR REPLACE TABLE gold.fact_sales AS
SELECT
    s.sls_ord_num AS order_number,

    -- Dimension foreign keys.
    c.customer_key,
    p.product_key,

    -- Transaction dates.
    s.sls_order_dt AS order_date,
    s.sls_ship_dt AS ship_date,
    s.sls_due_dt AS due_date,

    -- Business measures.
    s.sls_sales AS sales,
    s.sls_quantity AS quantity,
    s.sls_price AS price

FROM silver.crm_sales s

LEFT JOIN gold.dim_customer c
    ON s.sls_cust_id = c.customer_id

LEFT JOIN gold.dim_product p
    ON s.sls_prd_key = p.product_number

-- Retain only analytics-ready records with valid
-- data quality and matching dimensions.
WHERE s.invalid_order_date = FALSE
  AND s.invalid_sales_amount = FALSE
  AND s.invalid_quantity = FALSE
  AND s.invalid_price = FALSE
  AND p.product_key IS NOT NULL
  AND c.customer_key IS NOT NULL;
