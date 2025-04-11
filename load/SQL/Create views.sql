CREATE VIEW gold.final
AS
SELECT 
    *
FROM
    OPENROWSET(
        BULK 'https://deecomstorageaccount.blob.core.windows.net/deecom/silver/',
        FORMAT = 'PARQUET'
    ) AS raw;

CREATE OR ALTER VIEW gold.dimCustomer
AS
SELECT DISTINCT
    raw.customer_unique_id       AS CustomerID,
    raw.customer_zip_code_prefix AS CustomerZipCode,
    raw.customer_city            AS CustomerCity,
    raw.customer_state           AS CustomerState
FROM gold.final AS raw
WHERE raw.customer_unique_id IS NOT NULL;


CREATE OR ALTER VIEW gold.dimProduct
AS
SELECT DISTINCT
    raw.product_category_name            AS ProductCategoryOriginal,
    raw.product_category_name_english    AS ProductCategoryEnglish,
    raw.product_name_lenght             AS ProductNameLength,
    raw.product_description_lenght       AS ProductDescriptionLength,
    raw.product_photos_qty              AS ProductPhotosQty,
    raw.product_weight_g                AS ProductWeightGrams,
    raw.product_length_cm               AS ProductLengthCM,
    raw.product_height_cm               AS ProductHeightCM,
    raw.product_width_cm                AS ProductWidthCM
FROM gold.final AS raw
WHERE raw.product_category_name IS NOT NULL;

CREATE OR ALTER VIEW gold.dimSeller
AS
SELECT DISTINCT
    raw.seller_zip_code_prefix   AS SellerZipCode,
    raw.seller_city              AS SellerCity,
    raw.seller_state             AS SellerState
FROM gold.final AS raw
WHERE raw.seller_zip_code_prefix IS NOT NULL;