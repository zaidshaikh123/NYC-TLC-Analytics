WITH peak_hour_speed  AS (SELECT day_of_week,
AVG(avg_speed_mph) AS peak_hour_speed_mph
FROM {{ ref('mart_hourly_pricing_dynamics') }}
WHERE pickup_hour = 13 AND is_weekend = 'Weekday'
GROUP BY 1),

overnight_speed AS (SELECT day_of_week, AVG(avg_speed_mph) AS overnight_speed_mph
FROM {{ ref('mart_hourly_pricing_dynamics') }}
WHERE (pickup_hour >= 20 OR pickup_hour <= 5) AND is_weekend = 'Weekday'
GROUP BY 1)

SELECT p.day_of_week, peak_hour_speed_mph, (overnight_speed_mph - peak_hour_speed_mph) AS overnight_speed_drop
FROM peak_hour_speed AS p INNER JOIN overnight_speed AS o
ON p.day_of_week = o.day_of_week