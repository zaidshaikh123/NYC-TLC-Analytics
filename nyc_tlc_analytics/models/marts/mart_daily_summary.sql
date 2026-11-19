SELECT p.date_utc AS pickup_date, COUNT(*) AS trip_volume,
SUM(total_amount) AS total_revenue,
AVG(fare_amount) AS avg_fare
FROM {{ ref('fct_trips') }} AS f INNER JOIN {{ ref('dim_date') }} AS p
ON f.pickup_date_uid = p.id
WHERE is_likely_invalid IS false
GROUP BY 1
ORDER BY 1