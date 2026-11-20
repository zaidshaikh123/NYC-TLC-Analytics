SELECT pickup_zone,
AVG(avg_speed_mph) AS implied_avg_speed_mph,
APPROX_QUANTILES(median_speed_mph, 100)[OFFSET(50)] AS implied_median_speed_mph
FROM {{ ref('mart_hourly_pricing_dynamics') }}
GROUP BY 1
ORDER BY 2