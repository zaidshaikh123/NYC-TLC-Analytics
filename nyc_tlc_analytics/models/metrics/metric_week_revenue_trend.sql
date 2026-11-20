SELECT pickup_date, total_revenue,
AVG(total_revenue) OVER(ORDER BY pickup_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_revenue_7d
FROM {{ ref('mart_daily_summary') }}
ORDER BY pickup_date