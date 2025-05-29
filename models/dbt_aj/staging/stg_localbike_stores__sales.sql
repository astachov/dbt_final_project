{{ config(materialized='table') }}

/*
  stg_stores
  ----------
  Transformation de la source "stores".
  Colonnes attendues : store_id, store_name, phone, email, street, city, state, zip_code.
*/
select
    store_id,
    store_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code
from {{ source('localbike', 'stores') }} 
