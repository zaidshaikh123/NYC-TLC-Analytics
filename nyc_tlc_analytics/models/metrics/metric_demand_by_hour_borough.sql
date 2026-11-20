SELECT borough AS pickup_borough, dow AS pickup_dow, pickup_hour, COUNT(trip_id) AS count_trips
FROM {{ ref('fct_trips') }} AS ft INNER JOIN {{ ref('dim_date') }} AS dd
ON ft.pickup_date_uid = dd.id
INNER JOIN {{ ref('dim_zone') }} AS dz
ON ft.pickup_location_uid = dz.id
GROUP BY dow_num, pickup_dow, pickup_hour, pickup_borough
ORDER BY dow_num, pickup_hour