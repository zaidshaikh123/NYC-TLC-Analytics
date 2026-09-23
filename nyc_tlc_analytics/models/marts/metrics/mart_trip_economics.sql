SELECT month, borough, AVG(fare_amount) AS avg_fare_amount,
AVG(tip_percentage) AS avg_tip_percentage, AVG(trip_duration_mins) AS avg_trip_duration_mins,
AVG(trip_distance) AS avg_trip_distance
FROM {{ ref('fct_trips') }} AS ft INNER JOIN {{ ref('dim_date') }} AS dd
ON ft.pickup_date_uid = dd.id
INNER JOIN {{ ref('dim_zone') }} AS dz
ON ft.pickup_location_uid = dz.id
GROUP BY 1,2
ORDER BY 1, avg_fare_amount DESC