SELECT p.zone AS pickup_zone, d.zone AS dropoff_zone,
p.borough AS pickup_borough, d.borough AS dropoff_borough,
DATE_TRUNC(dt.date_utc, MONTH) AS pickup_month,
COUNT(*) AS trip_count,
AVG(fare_amount) AS avg_fare,
AVG(trip_distance) AS avg_distance,
COUNTIF(p.borough != d.borough) AS cross_borough_trip_count
FROM {{ ref('fct_trips') }} AS f INNER JOIN {{ ref('dim_zone') }} AS p
ON f.pickup_location_uid = p.id
INNER JOIN {{ ref('dim_zone') }} AS d
ON f.dropoff_location_uid = d.id
INNER JOIN {{ ref('dim_date') }} AS dt
ON f.pickup_date_uid = dt.id
WHERE is_likely_invalid IS NOT TRUE
GROUP BY 1,2,3,4,5