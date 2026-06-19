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
- Standardized `sls_prd_key` formatting for downstream joins.
- Replaced null product costs with `0`.
- Expanded product line abbreviations.
- Added `missing_start_date` quality flag.
- Added `invalid_date_range` quality flag.

## CRM Sales (`crm_sales`)
- Flagged invalid order dates.
- Converted order, ship, and due dates to Spark date format.
- Standardized `sls_prd_key` by replacing `-` with `_` to align with product dimension keys.
- Added quality flags for invalid sales amounts, quantities, and prices.
- Populated missing sales values when valid quantity and price values were available.
- Populated missing prices when valid sales and quantity values were available.

## ERP Customer (`erp_cust`)
- Removed source prefixes from `CID`.
- Added an `invalid_birth_date` quality flag.
- Replaced invalid birth dates with `NULL`.
- Expanded gender codes (`M` → `Male`, `F` → `Female`).
- Converted blank gender values to `NULL`.

## ERP Location (`erp_loc`)
- Removed hyphens from `CID`.
- Standardized country values (`US`, `USA` → `United States`).
- Converted blank country values to `NULL`.

## ERP Product (`erp_px_cat`)
- No data cleansing was required.
- Renamed the table to align with Silver layer naming conventions.
