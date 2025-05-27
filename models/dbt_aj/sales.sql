{{ config(materialized='table') }}

WITH ventes AS (
  SELECT
    oi.product_id,
    p.product_name  AS product_name,
    b.brand_name   AS brand_name,
    c.category_name   AS category_name,
    o.store_id,
    s.store_name   AS store_name,
    SUM(oi.quantity)                                AS volume,
    SUM(oi.quantity * oi.list_price)                AS chiffre_affaires,
    SUM(oi.quantity * (oi.list_price - p.list_price)) AS marge
  FROM {{ source('localbike','order_items') }} AS oi

  -- on passe aux vraies colonnes-clé
  JOIN {{ source('localbike','orders') }}     AS o ON o.order_id   = oi.order_id
  JOIN {{ source('localbike','products') }}   AS p ON p.product_id = oi.product_id
  JOIN {{ source('localbike','brands') }}     AS b ON b.brand_id   = p.brand_id
  JOIN {{ source('localbike','categories') }} AS c ON c.category_id= p.category_id
  JOIN {{ source('localbike','stores') }}     AS s ON s.store_id   = o.store_id

  WHERE o.order_date
    BETWEEN '{{ var("start_date","2016-01-01") }}'
        AND '{{ var("end_date",  "2016-03-31") }}'

  GROUP BY
    oi.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    o.store_id,
    s.store_name
)

SELECT *
FROM ventes
ORDER BY chiffre_affaires DESC