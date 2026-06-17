# Silver Layer Transformations

## CRM Customer (`crm_cust`)
- Retained only the most recent customer record using a window function.
- Removed records with missing customer IDs.
- Trimmed leading and trailing whitespace from customer names.
- Expanded marital status codes (`S` → `Single`, `M` → `Married`).
- Expanded gender codes (`M` → `Male`, `F` → `Female`).

## CRM Product (`crm_prd`)
- Derived `cat_id` from `prd_key`.
- Derived `sls_prd_key` from `prd_key`.
- Replaced null product costs with `0`.
- Expanded product line abbreviations.
- Added `missing_start_date` flag.
- Added `invalid_date_range` flag.

## CRM Sales (`crm_sales`)
- Flagged invalid order dates.
- Converted order, ship, and due dates to Spark date format.
- Added flags for invalid sales amount, quantity, and price.
- Populated missing sales values when quantity and price were available.
- Populated missing prices when sales and quantity were available.

## ERP Customer (`erp_cust`)
- Removed source prefixes from `CID`.
- Added `invalid_birth_date` flag.
- Replaced invalid birth dates with `NULL`.
- Standardized gender values.
- Converted blank gender values to `NULL`.

## ERP Location (`erp_loc`)
- Removed hyphens from `CID`.
- Standardized country values (`US`, `USA` → `United States`).
- Converted blank country values to `NULL`.

## ERP Product (`erp_px_cat`)
- No transformations required.
- Renamed for consistency with Silver layer naming conventions.
