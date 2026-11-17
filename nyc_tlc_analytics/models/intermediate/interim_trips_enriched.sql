WITH inter_trips_lookup AS (
    SELECT stgtrip.*,
    stgp.borough AS pickup_borough, stgp.zone AS pickup_zone, stgp.service_zone AS pickup_service_zone,
    stgd.borough AS dropoff_borough, stgd.zone AS dropoff_zone, stgd.service_zone AS dropoff_service_zone
    FROM {{ref('stg_taxi_trips')}} AS stgtrip
    INNER JOIN {{ref('stg_lookup')}} AS stgp
    ON stgtrip.pickup_location_id = stgp.location_id
    INNER JOIN {{ref('stg_lookup')}} AS stgd
    ON stgtrip.dropoff_location_id = stgd.location_id
),

enriched_data AS (
    SELECT *,
    (tip_amount/NULLIF(fare_amount,0)) AS tip_percentage,
    EXTRACT(HOUR FROM pickup_time) AS pickup_hour,
    fare_amount/NULLIF(trip_distance,0) AS fare_per_mile,
    trip_distance/NULLIF(trip_duration_mins/60.0 ,0) AS speed_mph,
    (CASE WHEN fare_amount < 0 OR passenger_count <= 0 OR (trip_distance <= 0 AND fare_amount > 0) OR trip_duration_mins <= 0 OR trip_distance/NULLIF(trip_duration_mins ,0) < 0 THEN TRUE
    ELSE FALSE END) AS is_likely_invalid,
    (CASE WHEN rate_code_id = 1 AND trip_distance BETWEEN 0.5 AND 50 AND fare_amount > 0 AND trip_duration_mins BETWEEN 1 AND 180 AND trip_distance/NULLIF(trip_duration_mins/60.0, 0) < 60 THEN TRUE ELSE FALSE END) AS is_efficiency_eligible
    FROM inter_trips_lookup
)

SELECT * FROM enriched_data