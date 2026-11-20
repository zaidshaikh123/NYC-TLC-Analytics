SELECT pickup_hour, is_weekend,
AVG(avg_fare_per_mile) AS implied_avg_fare_per_mile,
APPROX_QUANTILES(median_speed_mph, 100)[OFFSET(50)] AS implied_median_fare_per_mile
FROM {{ ref('mart_hourly_pricing_dynamics') }}
GROUP BY 1,2
ORDER BY 3