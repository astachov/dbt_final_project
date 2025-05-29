{{ config(materialized='view') }}

SELECT 
    product_id,
    product_name
FROM {{ source('localbike', 'products') }}