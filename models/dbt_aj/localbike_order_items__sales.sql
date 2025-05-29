SELECT 
order_id,
item_id,
product_id,
quantity,
list_price as unit_price,

FROM {{ source('localbike' , 'order_items')}}