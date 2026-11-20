SELECT *, (cross_borough_trip_count/trip_count)*100 AS cross_borough_trip_pct
FROM {{ ref('mart_od_flows') }}
ORDER BY avg_fare DESC
LIMIT 15