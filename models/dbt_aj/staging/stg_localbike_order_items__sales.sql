{{ config(materialized='view') }}

SELECT 
    order_id,
    product_id,
    quantity,
    list_price
FROM {{ source('localbike', 'order_items') }}