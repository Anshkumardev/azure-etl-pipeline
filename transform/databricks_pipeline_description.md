
# 🧪 Data Transformation & Enrichment Pipeline (Azure Databricks)

This transformation pipeline cleans, processes, and enriches raw e-commerce data ingested from GitHub and MySQL (stored in Azure Data Lake Gen2) using Apache Spark on Azure Databricks. Additionally, it joins the processed data with metadata stored in MongoDB, preparing the final output for downstream analytics in Azure Synapse or Power BI.

---

## 🧱 Pipeline Architecture

```
         ┌────────────────────┐
         │ Raw Data in ADLS   │
         │ (GitHub + MySQL)   │
         └────────┬───────────┘
                  │
        ┌─────────▼──────────┐
        │ Azure Databricks   │
        │ (Spark Notebooks)  │
        └─────────┬──────────┘
                  │
     ┌────────────▼────────────┐
     │ Cleansing + Enrichment  │ <─┐
     └────────────┬────────────┘   │
                  │                │
        ┌─────────▼──────────┐     │
        │ MongoDB NoSQL Data │─────┘
        └─────────┬──────────┘
                  │
         ┌────────▼────────┐
         │ Curated Layer   │
         │ in ADLS Gen2    │
         └─────────────────┘
```

---

## 🔗 Input Sources

| Dataset                     | Source                   | Format | Purpose |
|-----------------------------|--------------------------|--------|---------|
| olist_orders_dataset        | ADLS Gen2 (bronze)       | CSV    | Order-level metadata |
| olist_order_payments        | ADLS Gen2 (bronze)       | CSV    | Payment transactions |
| olist_order_reviews         | ADLS Gen2 (bronze)       | CSV    | Customer review data |
| olist_order_items           | ADLS Gen2 (bronze)       | CSV    | Product-level order items |
| olist_customers             | ADLS Gen2 (bronze)       | CSV    | Customer profile and region |
| olist_sellers               | ADLS Gen2 (bronze)       | CSV    | Seller metadata |
| olist_geolocation           | ADLS Gen2 (bronze)       | CSV    | Location coordinates |
| olist_products              | ADLS Gen2 (bronze)       | CSV    | Product metadata |
| product_categories          | MongoDB (Filess.io)      | BSON   | Product category labels |

---

## 🔧 Transformation Logic

### 1. Read Raw Files from ADLS Gen2

```python
df = spark.read.csv("abfss://<container>@<account>.dfs.core.windows.net/bronze/olist_orders_dataset.csv", header=True)
```

This is done for each dataset. All files are loaded with proper schema inference and headers enabled.

### 2. Data Cleansing

```python
df_clean = df_raw.dropDuplicates().dropna(subset=["customer_id"])
df_clean = df_clean.withColumn("order_date", to_date("order_purchase_timestamp"))
```

### 3. MongoDB Enrichment

```python
from pymongo import MongoClient
client = MongoClient("mongodb://<user>:<pass>@<host>:<port>/<db>")
product_categories_df = pd.DataFrame(list(client["db"]["product_categories"].find()))
```

Join with product data:

```python
mongo_spark_df = spark.createDataFrame(product_categories_df)
enriched_df = products_df.join(mongo_spark_df, on="product_category_name", how="left")
```

### 4. Data Modeling and Joins

Join datasets into a star schema:

- orders + payments
- orders + reviews
- orders + items + enriched products

### 5. Write to ADLS Curated Layer

```python
output_path = "abfss://<container>@<account>.dfs.core.windows.net/curated/fact_orders"
final_df.write.mode("overwrite").format("parquet").save(output_path)
```

---

## 🗂️ Output Datasets

| Path                             | Format  | Description |
|----------------------------------|---------|-------------|
| curated/fact_orders/             | Parquet | Orders with payments and reviews |
| curated/dim_customers/           | Parquet | Customer dimension |
| curated/dim_products_enriched/   | Parquet | Enriched product info from MongoDB |

---

## 📁 Folder Structure

```
transform/
├── databricks_pipeline_description.md
├── notebooks/
│   └── Data_Transformation.ipynb
├── scripts/
│   ├── spark_session.py
│   └── enrichment_utils.py
├── sample_output/
│   ├── dim_products_enriched.parquet
│   └── fact_orders.parquet
```

---

## ✅ Highlights

- Handles multi-source integration (structured + semi-structured)
- Leverages Spark for distributed processing
- Enriches product data using NoSQL (MongoDB)
- Produces analytics-ready datasets in a star schema format

---

## 📌 Future Enhancements

- Automate execution with Databricks Jobs
- Integrate Great Expectations for data quality checks
- Convert outputs to Delta Lake for versioning and time travel

---

## 👨‍💻 Author

**Ansh Kumar Dev**  
Graduate Student, Data Science – University of Arizona  
GitHub: [Anshkumardev](https://github.com/Anshkumardev)
