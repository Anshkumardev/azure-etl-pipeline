# 🔄 Dynamic Ingestion Pipeline (Azure Data Factory)

This pipeline performs dynamic data extraction from **multiple sources** — including GitHub (via REST API) and a MySQL server — and stores the ingested data in Azure Data Lake Gen2 for further processing.

---

## 🌐 Linked Services

| Name                        | Type                  | Purpose |
|-----------------------------|-----------------------|---------|
| `ADLSForCSV`               | Azure Data Lake Gen2  | Writes GitHub REST API output in CSV format |
| `filessSQLDB`              | MySQL                 | Connects to MySQL server for structured transactional data |
| `HttpGithubLinkedService`  | HTTP (REST)           | Base connection to GitHub API (`https://api.github.com`) |
| `JSONFromGithubForLoop`    | HTTP (REST)           | Supports iteration through dynamic GitHub endpoints in a ForEach loop |
| `SQLToADLSLinkedService`   | Azure Data Lake Gen2  | Writes MySQL table data to the curated zone of ADLS Gen2 |

---

## 🔧 Pipeline Components

| Component           | Description |
|---------------------|-------------|
| `Lookup1`           | Retrieves a list of GitHub endpoints or MySQL tables for ingestion |
| `ForEach1`          | Iterates over the items retrieved in `Lookup1` |
| `CopyInsideForEach` | Dynamically copies data using REST API or SQL query with parameters |
| `DataFromSQL`       | Optional step to finalize MySQL-to-ADLS ingestion |

---

## ⚙️ Example Use Case

- **GitHub Source:** Pull metadata such as contributors, issues, or commit history from public repositories using REST API.
- **MySQL Source:** Extract transactional or e-commerce datasets such as `orders`, `products`, or `customers`.
- **Output:** Store raw and enriched datasets separately in Azure Data Lake Gen2 for transformation by Databricks.

---

## 🧪 Parameterization Examples

### 🗄️ MySQL Table Extraction
```json
"source": {
  "type": "MySqlSource",
  "sqlReaderQuery": "SELECT * FROM @{item().TableName}"
}
