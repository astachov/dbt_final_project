{{ config(materialized = 'table') }}

WITH customer_orders AS (
  SELECT
    o.customer_id,
    oi.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price) AS order_revenue
  FROM {{ source('localbike','orders') }}      AS o
  JOIN {{ source('localbike','order_items') }} AS oi
    ON oi.order_id = o.order_id
  GROUP BY
    o.customer_id,
    oi.order_id,
    o.order_date
),

customer_ltv AS (
  SELECT
    customer_id,
    SUM(order_revenue) AS lifetime_value
  FROM customer_orders
  GROUP BY customer_id
)

SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  COALESCE(l.lifetime_value,0) AS customer_lifetime_value
FROM {{ source('localbike','customers') }} AS c
LEFT JOIN customer_ltv AS l
  ON l.customer_id = c.customer_id
ORDER BY customer_lifetime_value DESC