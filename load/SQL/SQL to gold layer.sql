-- CREATE MASTER kEY ENCRYPTION BY PASSWORD = 'anshsynapse@2025'
-- CREATE DATABASE SCOPED CREDENTIAL anshadmin WITH IDENTITY = 'Managed Identity'

DROP EXTERNAL TABLE IF EXISTS gold.dimProduct_ext;  -- In case it already exists

CREATE EXTERNAL TABLE gold.dimProduct_ext
WITH (
    LOCATION = 'dimProduct/',          -- This is a subfolder under your 'gold/' path
    DATA_SOURCE = goldlayer,           -- The external data source you created
    FILE_FORMAT = extFileFormat
)
AS
SELECT DISTINCT
    product_category_name            AS ProductCategoryOriginal,
    product_category_name_english    AS ProductCategoryEnglish,
    product_name_lenght             AS ProductNameLength,
    product_description_lenght       AS ProductDescriptionLength,
    product_photos_qty              AS ProductPhotosQty,
    product_weight_g                AS ProductWeightGrams,
    product_length_cm               AS ProductLengthCM,
    product_height_cm               AS ProductHeightCM,
    product_width_cm                AS ProductWidthCM
FROM gold.final AS raw   -- or gold.dimProduct if you prefer
WHERE raw.product_category_name IS NOT NULL;

DROP EXTERNAL TABLE IF EXISTS gold.dimCustomer_ext;

CREATE EXTERNAL TABLE gold.dimCustomer_ext
WITH (
    LOCATION = 'dimCustomer/',
    DATA_SOURCE = goldlayer,       -- The external data source pointing to your gold path
    FILE_FORMAT = extFileFormat    -- Parquet file format
)
AS
SELECT DISTINCT
    raw.customer_unique_id       AS CustomerID,
    raw.customer_zip_code_prefix AS CustomerZipCode,
    raw.customer_city            AS CustomerCity,
    raw.customer_state           AS CustomerState
FROM gold.final AS raw
WHERE raw.customer_unique_id IS NOT NULL;

DROP EXTERNAL TABLE IF EXISTS gold.dimSeller_ext;

CREATE EXTERNAL TABLE gold.dimSeller_ext
WITH (
    LOCATION = 'dimSeller/',
    DATA_SOURCE = goldlayer,
    FILE_FORMAT = extFileFormat
)
AS
SELECT DISTINCT
    raw.seller_zip_code_prefix   AS SellerZipCode,
    raw.seller_city              AS SellerCity,
    raw.seller_state             AS SellerState
FROM gold.final AS raw
WHERE raw.seller_zip_code_prefix IS NOT NULL;


