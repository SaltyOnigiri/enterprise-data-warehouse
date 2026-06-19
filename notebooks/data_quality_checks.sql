-- Check for null customer keys in Gold fact table
SELECT COUNT(*) AS null_customer_keys
FROM gold.fact_sales
WHERE customer_key IS NULL;

-- Check for null product keys in Gold fact table
SELECT COUNT(*) AS null_product_keys
FROM gold.fact_sales
WHERE product_key IS NULL;

-- Check for duplicate customer dimension keys
SELECT customer_key, COUNT(*) AS record_count
FROM gold.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- Check for duplicate product dimension keys
SELECT product_key, COUNT(*) AS record_count
FROM gold.dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;

-- Check for invalid sales values in Gold
SELECT COUNT(*) AS invalid_sales_records
FROM gold.fact_sales
WHERE sales <= 0
   OR quantity <= 0
   OR price <= 0;
