{{ config(materialized='table') }}

WITH ventes AS (
  SELECT
    oi.product_id,
    p.product_name  AS product_name,
    b.brand_id AS brand_id,
    b.brand_name   AS brand_name,
    c.category_name   AS category_name,
    o.store_id,
    s.store_name   AS store_name,
    SUM(oi.quantity)                                AS volume,
    SUM(oi.quantity * oi.list_price)                AS chiffre_affaires,
    SUM(oi.quantity * (oi.list_price - p.list_price)) AS marge
  FROM {{ ref('stg_localbike_order_items__sales') }} AS oi

  JOIN {{ ref('stg_localbike_orders__sales') }}     AS o ON o.order_id   = oi.order_id
  JOIN {{ ref('stg_localbike_products__production') }}   AS p ON p.product_id = oi.product_id
  JOIN {{ ref('stg_localbike_brands__production') }}     AS b ON b.brand_id   = p.brand_id
  JOIN {{ ref('stg_localbike_categories__production') }} AS c ON c.category_id= p.category_id
  JOIN {{ ref('stg_localbike_stores__sales') }}     AS s ON s.store_id   = o.store_id

  WHERE o.order_date
    BETWEEN '{{ var("start_date","2016-01-01") }}'
        AND '{{ var("end_date",  "2018-12-31") }}'

  GROUP BY
    oi.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    o.store_id,
    s.store_name,
    b.brand_id
)

SELECT *
FROM ventes
ORDER BY chiffre_affaires DESC