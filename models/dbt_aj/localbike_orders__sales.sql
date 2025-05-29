SELECT 
order_id,
customer_id,
order_status,
order_date,

FROM {{ source('localbike' , 'orders')}}