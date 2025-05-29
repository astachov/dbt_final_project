SELECT 
order_id,
customer_id,
order_status,
order_date,
store_id
FROM {{ source('localbike' , 'orders')}}