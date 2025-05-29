SELECT 
staff_id,
first_name,
last_name,
email,
manager_id,
store_id,
active,
phone,

FROM {{ source('localbike' , 'staffs') }}