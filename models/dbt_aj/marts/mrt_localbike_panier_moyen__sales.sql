{{ config(materialized='table') }}

WITH order_revenue AS (
  SELECT
    DATE_TRUNC(o.order_date, MONTH)       AS month,
    oi.order_id,
    ROUND(SUM(oi.quantity * oi.list_price),2)     AS revenue
  FROM {{ ref('stg_localbike_orders') }} AS o
  JOIN {{ ref('stg_localbike_order_items') }} AS oi
    ON oi.order_id = o.order_id
  GROUP BY
    month,
    oi.order_id
),

monthly_basket AS (
  SELECT
    month,
    COUNT(DISTINCT order_id)                           AS nb_orders,
    ROUND(SUM(revenue),2)                                       AS total_revenue,
    ROUND(ROUND(SAFE_DIVIDE(SUM(revenue),2), COUNT(DISTINCT order_id)),2) AS avg_basket_value
  FROM order_revenue
  GROUP BY month
)

SELECT
  month,
  nb_orders,
  total_revenue,
  avg_basket_value
FROM monthly_basket
ORDER BY month