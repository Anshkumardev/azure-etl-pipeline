
# 🚀 Azure-Based Scalable ETL Pipeline for E-Commerce Analytics

This project demonstrates a complete, modular ETL pipeline built using Microsoft Azure tools to process, transform, and serve large-scale e-commerce data for analytics and business intelligence. The pipeline follows a medallion architecture (bronze → silver → gold) and uses Azure Data Factory, Databricks, Synapse Analytics, and Power BI.

---

## 🔄 Full Workflow Overview

```text
                    ┌──────────────────────────────┐
                    │    External Data Sources     │
                    │ • GitHub REST API (JSON)     │
                    │ • MySQL (Relational DB)      │
                    └────────────┬─────────────────┘
                                 │
                      ┌──────────▼─────────┐
                      │ Azure Data Factory │
                      │ (Ingestion Layer)  │
                      └──────────┬─────────┘
                                 │
                      ┌──────────▼─────────┐
                      │  Azure Data Lake   │
                      │  (Bronze Layer)    │
                      └──────────┬─────────┘
                                 │
                      ┌──────────▼────────────┐
                      │ Azure Databricks      │
                      │ (Transformation Logic │
                      │ + MongoDB Enrichment) │
                      └──────────┬────────────┘
                                 │
                      ┌──────────▼─────────┐
                      │  ADLS Gen2 (Gold)  │
                      └──────────┬─────────┘
                                 │
                      ┌──────────▼──────────────┐
                      │  Azure Synapse Analytics│
                      │  (Views + External Tables)
                      └──────────┬──────────────┘
                                 │
                      ┌──────────▼──────────┐
                      │   Power BI / Fabric │
                      │   (Reporting Layer) │
                      └─────────────────────┘
```

---

## 🧱 Architecture Layers

- **Extract**: Uses Azure Data Factory to pull structured and semi-structured data from GitHub APIs and MySQL, loading into Azure Data Lake (Bronze).
- **Transform**: Azure Databricks (Spark) handles data cleaning, joining, and enrichment using MongoDB product metadata.
- **Load**: Azure Synapse creates views and external tables over the curated data for efficient querying.
- **Visualize**: Power BI or Microsoft Fabric reads from Synapse to build dashboards.

---

## 📂 Folder Structure

```
.
├── extract/                          # Data ingestion (ADF pipeline + linked services)
│   ├── dynamic_copy_pipeline_description.md
│   ├── linked_services/
│   └── datasets/
│
├── transform/                        # Data transformation in Databricks
│   ├── databricks_pipeline_description.md
│   ├── notebooks/
│   └── sample_output/
│
├── load/                             # Data modeling + querying in Synapse
│   ├── synapse_pipeline_description.md
│   ├── views/
│   ├── external_tables/
│   └── setup/
│
├── docs/                             # Supporting visuals and diagrams
│   ├── full_architecture_diagram.txt
│   └── architecture_images/
│
└── README.md                         # This file
```

---

## 🧪 Data Sources Used

- **MySQL**: E-commerce operational tables (orders, users, products)
- **GitHub API**: Metadata from repositories
- **MongoDB**: External enrichment for product categories
- **ADLS Gen2**: Lake storage at all layers (bronze, silver, gold)

---

## 🧠 Features

- Metadata-driven ingestion using ADF (Lookup + ForEach)
- Spark-based data modeling, enrichment, and transformation
- External table creation in Synapse for direct lake access
- Modular, reusable architecture with clean separation of concerns
- Supports Power BI integration without data duplication

---

## 📊 Dashboards & Output

- **Fact Tables**: Orders, payments, enriched products
- **Dimension Tables**: Customers, Products, Sellers
- **Star Schema Views**: Created in Synapse for querying
- **Power BI/Fabric Dashboards**: Interactive KPI analysis

---

## 🧰 Technologies Used

| Category       | Tools / Services |
|----------------|------------------|
| Ingestion      | Azure Data Factory, GitHub REST API, MySQL |
| Storage        | Azure Data Lake Gen2 |
| Processing     | Azure Databricks, Apache Spark |
| Enrichment     | MongoDB |
| Modeling       | Azure Synapse Analytics |
| Visualization  | Power BI / Microsoft Fabric |

---

## 📌 Future Improvements

- Automate pipeline execution with Azure Data Factory triggers
- Add CI/CD deployment for ADF + Synapse using GitHub Actions
- Implement Delta Lake for better time travel and updates
- Integrate data validation (Great Expectations or PyDeequ)

---

## 👨‍💻 Author

**Ansh Kumar Dev**  
Graduate Student, Data Science – University of Arizona  
📫 GitHub: [Anshkumardev](https://github.com/Anshkumardev)  
🔗 LinkedIn: [linkedin.com/in/anshkumardev](https://linkedin.com/in/anshkumardev)
