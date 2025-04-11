
# 🗃️ Data Loading & Modeling in Azure Synapse

This stage represents the final **load** phase of the ETL pipeline, where transformed and enriched datasets stored in **Azure Data Lake Gen2** are made queryable using **external tables** and **views** in **Azure Synapse Analytics**. This structure supports analytics, reporting, and dashboarding via Power BI or Microsoft Fabric.

---

## 🔗 Data Source

- **Source Format:** Parquet
- **Source Location:** Azure Data Lake Storage (Curated Layer)
- **Accessed via:** `OPENROWSET` and External Tables in Synapse

---

## 📥 Data Ingestion Strategy

### 1. Create a Raw View over Parquet Files

```sql
CREATE VIEW gold.final AS
SELECT * 
FROM OPENROWSET(
    BULK 'https://deecomstorageaccount.blob.core.windows.net/deecom/silver/',
    FORMAT = 'PARQUET'
) AS raw;
```

This view represents the unified curated dataset stored in the “silver” layer of ADLS Gen2.

---

## 🧱 Star Schema Design

### 2. Dimension Views

#### dimCustomer View
```sql
CREATE OR ALTER VIEW gold.dimCustomer AS
SELECT DISTINCT
    raw.customer_unique_id AS CustomerID,
    raw.customer_zip_code_prefix AS CustomerZipCode,
    raw.customer_city AS CustomerCity,
    raw.customer_state AS CustomerState
FROM gold.final AS raw
WHERE raw.customer_unique_id IS NOT NULL;
```

#### dimProduct View
```sql
CREATE OR ALTER VIEW gold.dimProduct AS
SELECT DISTINCT
    raw.product_category_name AS ProductCategoryOriginal,
    raw.product_category_name_english AS ProductCategoryEnglish,
    raw.product_name_lenght AS ProductNameLength,
    raw.product_description_lenght AS ProductDescriptionLength,
    raw.product_photos_qty AS ProductPhotosQty,
    raw.product_weight_g AS ProductWeightGrams,
    raw.product_length_cm AS ProductLengthCM,
    raw.product_height_cm AS ProductHeightCM,
    raw.product_width_cm AS ProductWidthCM
FROM gold.final AS raw
WHERE raw.product_category_name IS NOT NULL;
```

#### dimSeller View
```sql
CREATE OR ALTER VIEW gold.dimSeller AS
SELECT DISTINCT
    raw.seller_zip_code_prefix AS SellerZipCode,
    raw.seller_city AS SellerCity,
    raw.seller_state AS SellerState
FROM gold.final AS raw
WHERE raw.seller_zip_code_prefix IS NOT NULL;
```

---

## 🌐 External Table Creation

### External Table Setup (Parquet Files)

External tables are created over the views for performance, partitioning, and Power BI integration:

#### dimProduct External Table
```sql
CREATE EXTERNAL TABLE gold.dimProduct_ext
WITH (
    LOCATION = 'dimProduct/',
    DATA_SOURCE = goldlayer,
    FILE_FORMAT = extFileFormat
)
AS
SELECT DISTINCT ...
FROM gold.final AS raw
WHERE raw.product_category_name IS NOT NULL;
```

#### dimCustomer External Table
```sql
CREATE EXTERNAL TABLE gold.dimCustomer_ext
WITH (
    LOCATION = 'dimCustomer/',
    DATA_SOURCE = goldlayer,
    FILE_FORMAT = extFileFormat
)
AS
SELECT DISTINCT ...
FROM gold.final AS raw
WHERE raw.customer_unique_id IS NOT NULL;
```

#### dimSeller External Table
```sql
CREATE EXTERNAL TABLE gold.dimSeller_ext
WITH (
    LOCATION = 'dimSeller/',
    DATA_SOURCE = goldlayer,
    FILE_FORMAT = extFileFormat
)
AS
SELECT DISTINCT ...
FROM gold.final AS raw
WHERE raw.seller_zip_code_prefix IS NOT NULL;
```

---

## 📊 Output Ready for

- **Azure Synapse Studio:** Ad hoc SQL analysis
- **Power BI:** Direct Lake queries via external tables
- **Dashboards:** Aggregation, filtering, KPIs using star schema

---

## ✅ Benefits

- Lakehouse-style querying via external tables
- Separation of compute (Synapse) and storage (ADLS)
- No data movement or duplication required
- Efficient for reporting and scalable querying

---

## 👨‍💻 Author

**Ansh Kumar Dev**  
Graduate Student, Data Science – University of Arizona  
GitHub: [Anshkumardev](https://github.com/Anshkumardev)
