SELECT *
FROM {{ ref('fct_trips') }}
WHERE trip_duration_mins < 1 OR trip_duration_mins > 180 OR trip_distance > 100 OR (trip_distance <= 0 AND fare_amount > 0)