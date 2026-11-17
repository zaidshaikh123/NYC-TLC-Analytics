WITH stats AS (SELECT p.borough AS pickup_borough, pickup_hour,
AVG(fare_per_mile) AS mean_fpm,
STDDEV(fare_per_mile) AS stddev_fpm
FROM {{ ref('fct_trips') }} AS f INNER JOIN {{ ref('dim_zone') }} AS p
ON f.pickup_location_uid = p.id
GROUP BY 1,2)

SELECT f.*, p.borough AS pickup_borough, (fare_per_mile - mean_fpm)/NULLIF(stddev_fpm, 0) AS fare_per_mile_zscore
FROM {{ ref('fct_trips') }} AS f INNER JOIN {{ ref('dim_zone') }} AS p
ON f.pickup_location_uid = p.id
INNER JOIN stats AS s
ON p.borough = s.pickup_borough AND f.pickup_hour = s.pickup_hour