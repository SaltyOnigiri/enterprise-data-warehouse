# Architecture Design

## Architecture Choice

This project uses a **Medallion Architecture** consisting of **Bronze**, **Silver**, and **Gold** layers.

The architecture was selected to separate raw data ingestion, data transformation, and business-ready analytics into distinct stages. This approach improves maintainability, data quality, and scalability while supporting analytical workloads.

---

## Layer Definitions

### Bronze Layer

Stores raw ERP and CRM source data with minimal transformations. This layer serves as the system of record for incoming datasets and preserves the original source data for auditing and troubleshooting purposes.

### Silver Layer

Applies data cleansing, standardization, validation, and business rules. Data quality issues are resolved and datasets are transformed into a consistent structure before analytical modeling.

### Gold Layer

Contains dimensional models optimized for reporting and analytics, including fact and dimension tables designed to support business intelligence, dashboarding, and ad-hoc analysis.

---

## Benefits

- Clear separation of responsibilities across data processing stages
- Improved data quality management and validation
- Easier troubleshooting and root cause analysis
- Simplified reporting and analytical workflows
- Scalable design pattern widely adopted in modern data platforms

---

## Architecture Diagram

```
ERP CSV Files ──┐
                │
CRM CSV Files ──┤
                ▼
         Bronze Layer
        (Raw Ingestion)
                ▼
         Silver Layer
      (Data Cleansing &
       Transformation)
                ▼
          Gold Layer
      (Dimensional Model)
                ▼
      Reports & Analytics
```
