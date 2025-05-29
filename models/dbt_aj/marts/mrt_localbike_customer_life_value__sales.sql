{{ config(materialized='table') }}

WITH product_sales AS (

  SELECT
    oi.product_id,
    SUM(oi.quantity)                 AS total_quantity_sold,
    SUM(oi.quantity * oi.list_price) AS total_revenue
  FROM {{ ref('stg_localbike_order_items__sales') }} AS oi
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
JOIN {{ ref('stg_localbike_products__production') }} AS p
  ON rp.product_id = p.product_id
WHERE rp.product_rank <= 20
ORDER BY rp.total_revenue DESC