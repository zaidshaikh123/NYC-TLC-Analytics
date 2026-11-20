WITH weekly_summary AS (SELECT DATE_TRUNC(pickup_date, WEEK) AS pickup_week,
COUNT(pickup_date) AS no_of_days,
SUM(total_revenue) AS weekly_total_revenue
FROM {{ref('mart_daily_summary')}}
GROUP BY 1),

revenue_change AS (SELECT *,
LAG(weekly_total_revenue) OVER(ORDER BY pickup_week) AS previous_week_revenue
FROM weekly_summary)

SELECT *,
((weekly_total_revenue - previous_week_revenue)/NULLIF(previous_week_revenue,0))*100 AS revenue_growth_pct
FROM revenue_change
ORDER BY pickup_week
