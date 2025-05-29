{{ config(materialized='view') }}

SELECT 
    brand_id,
    brand_name
FROM {{ source('localbike', 'brands') }}