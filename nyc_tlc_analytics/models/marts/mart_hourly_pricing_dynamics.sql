SELECT p.zone AS pickup_zone, pickup_hour, dow AS day_of_week, is_weekend,
COUNT(*) AS trip_count,
SAFE_DIVIDE(SUM(fare_amount),SUM(trip_distance)) AS avg_fare_per_mile,
SAFE_DIVIDE(SUM(trip_distance), SUM(trip_duration_mins) / 60.0) AS avg_speed_mph,
APPROX_QUANTILES(speed_mph,100)[OFFSET(50)] AS median_speed_mph
FROM {{ ref('fct_trips') }} AS f INNER JOIN {{ ref('dim_zone') }} AS p
ON f.pickup_location_uid = p.id
INNER JOIN {{ ref('dim_date') }} AS dt
ON f.pickup_date_uid = dt.id
WHERE is_efficiency_eligible IS TRUE
GROUP BY 1,2,3,4