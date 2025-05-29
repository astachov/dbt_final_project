SELECT 
    customer_id,
    first_name,
    last_name,
    -- Autres colonnes
FROM {{ source('localbike', 'customers') }}