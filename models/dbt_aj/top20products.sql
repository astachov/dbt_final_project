{{ config(materialized='table') }}

{# On définit nos sources pour qualifier correctement les tables #}
{% set order_items = source('localbike', 'order_items') %}
{% set products    = source('localbike', 'products') %}

WITH product_sales AS (

  SELECT
    oi.product_id,
    SUM(oi.quantity)                 AS total_quantity_sold,
    SUM(oi.quantity * oi.list_price) AS total_revenue
  FROM {{ order_items }} AS oi
  GROUP BY oi.product_id

),

ranked_products AS (

  SELECT
    ps.*,
    ROW_NUMBER() OVER (ORDER BY ps.total_revenue DESC) AS product_rank
  FROM product_sales AS ps

)

SELECT
  rp.product_id,
  p.product_name,
  rp.total_quantity_sold,
  rp.total_revenue
FROM ranked_products AS rp
JOIN {{ products }} AS p
  ON rp.product_id = p.product_id
WHERE rp.product_rank <= 20
ORDER BY rp.total_revenue DESC