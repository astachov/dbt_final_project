{{ config(materialized='view') }}

SELECT 
    order_id,
    order_date,
    customer_id 
FROM {{ source('localbike', 'orders') }}