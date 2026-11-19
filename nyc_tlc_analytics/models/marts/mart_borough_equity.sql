SELECT p.borough AS pickup_borough,
DATE_TRUNC(dt.date_utc, MONTH) AS pickup_month, COUNT(*) AS trip_count,
AVG(trip_distance) AS avg_distance, AVG(fare_amount) AS avg_fare,
AVG(CASE WHEN payment_type = 1 THEN tip_amount/NULLIF(fare_amount,0) END)*100 AS avg_tip_pct_card_only,
SAFE_DIVIDE(
    SUM(IF(is_efficiency_eligible, trip_distance, 0)),
    SUM(IF(is_efficiency_eligible, trip_duration_mins, 0)) / 60.0
) AS avg_speed_mph
FROM {{ ref('fct_trips') }} AS f INNER JOIN {{ ref('dim_date') }} AS dt
ON f.pickup_date_uid = dt.id
INNER JOIN {{ ref('dim_zone') }} AS p
ON f.pickup_location_uid = p.id
GROUP BY 1,2