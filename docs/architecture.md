# Architecture Design

## Architecture Choice

This project uses a **Medallion Architecture** consisting of **Bronze**, **Silver**, and **Gold** layers.

The architecture was selected to separate raw data ingestion, data transformation, and business-ready analytics into distinct stages. This approach improves maintainability, data quality, and scalability while supporting analytical workloads.

---

## Layer Definitions

### Bronze Layer

The Bronze layer stores raw ERP and CRM source data with minimal transformations. Data is loaded as received from source systems to preserve traceability, support auditing requirements, and simplify troubleshooting.

**Characteristics**

- Raw source data
- Minimal transformations
- Full-load ingestion
- Table-based storage
- System of record for incoming datasets

### Silver Layer

The Silver layer applies data cleansing, standardization, validation, and transformation processes. Data quality issues are identified and addressed through cleansing, validation, and business rule enforcement while preserving trustworthy records for downstream analytics.

**Characteristics**

- Data cleansing
- Duplicate removal
- Data standardization
- Data validation
- Business rule enforcement
- Derived columns and transformations

### Gold Layer

The Gold layer contains business-ready dimensional models optimized for reporting and analytics. Data from multiple source systems is integrated and transformed into fact and dimension structures that support business intelligence, dashboarding, and ad-hoc analysis.

**Characteristics**

- Data integration
- Business logic implementation
- Aggregated analytical datasets
- Fact and dimension models
- Reporting and analytics consumption layer
- Table-based storage

---

## Implementation Details

| Layer | Object Type | Load Method | Purpose |
|---------|---------|---------|---------|
| Bronze | Tables | Full Load | Raw data ingestion |
| Silver | Tables | Full Load | Data cleansing and transformation |
| Gold | Tables | Full Load | Reporting and analytics |

---

## Benefits

- Clear separation of responsibilities across data processing stages
- Improved data quality management and validation
- Easier troubleshooting and root cause analysis
- Simplified reporting and analytical workflows
- Scalable design pattern widely adopted in modern data platforms

---

## Architecture Diagram

![Architecture Diagram](../diagrams/data_architecture.png)
```
