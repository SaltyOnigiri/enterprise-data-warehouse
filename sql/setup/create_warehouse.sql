-- =========================================================
-- Enterprise Data Warehouse
-- Databricks Workspace Initialization
--
-- Purpose:
-- Create the warehouse catalog and Medallion Architecture
-- schemas used throughout the project.
--
-- Architecture:
-- enterprise_dw
-- ├── bronze  (raw source data)
-- ├── silver  (cleaned and standardized data)
-- └── gold    (business-ready dimensional models)
-- =========================================================

-- Create project catalog
CREATE CATALOG IF NOT EXISTS enterprise_dw;

-- Set active catalog
USE CATALOG enterprise_dw;

-- Create Bronze layer for raw source ingestion
CREATE SCHEMA IF NOT EXISTS bronze;

-- Create Silver layer for data cleansing and transformation
CREATE SCHEMA IF NOT EXISTS silver;

-- Create Gold layer for dimensional modeling and analytics
CREATE SCHEMA IF NOT EXISTS gold;
