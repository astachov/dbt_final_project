{{ config(materialized = 'table') }}

WITH
  -- 1 On récupère les clients actifs par mois
  monthly_activity AS (
    SELECT
      DATE_TRUNC(o.order_date, MONTH) AS month,
      COUNT(DISTINCT o.customer_id)   AS active_customers
    FROM `databird-analytics.localbike.orders` AS o
    GROUP BY 1
  ),

  -- 2 On fait suivre (LAG) pour avoir le mois précédent
  with_prev AS (
    SELECT
      month,
      active_customers,
      LAG(active_customers) OVER (ORDER BY month) AS prev_active_customers
    FROM monthly_activity
  )

-- 3 On calcule le churn rate : (anciens – nouveaux) / anciens
SELECT
  month,
  prev_active_customers,
  active_customers,
  CASE
    WHEN prev_active_customers IS NULL THEN NULL
    ELSE SAFE_DIVIDE(prev_active_customers - active_customers, prev_active_customers)
  END AS churn_rate
FROM with_prev
ORDER BY month