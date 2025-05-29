{{ config(materialized='view') }}

SELECT 
    product_id,
    product_name,
    brand_id,
    list_price,
    category_id
FROM {{ source('localbike', 'products') }} AS p