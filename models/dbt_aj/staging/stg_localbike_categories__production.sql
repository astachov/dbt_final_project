{{ config(materialized='view') }}

SELECT 
    category_id,
    category_name
FROM {{ source('localbike', 'categories') }}