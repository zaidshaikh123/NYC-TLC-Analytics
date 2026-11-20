WITH trips_borough AS (SELECT pickup_borough, DATE_TRUNC(dt.date_utc, MONTH) AS pickup_month,
COUNT(*) AS anomaly_trip_count
FROM {{ ref('mart_trip_anomalies_statistical') }} AS an INNER JOIN {{ ref('dim_date') }} AS dt
ON an.pickup_date_uid = dt.id
WHERE fare_per_mile_zscore > 3
GROUP BY 1,2)

SELECT *, anomaly_trip_count/(SELECT SUM(anomaly_trip_count) FROM trips_borough) AS anomaly_trip_perc
FROM trips_borough