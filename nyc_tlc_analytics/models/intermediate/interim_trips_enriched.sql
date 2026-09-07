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
    SELECT *, TIMESTAMP_DIFF(dropoff_dt, pickup_dt, MINUTE) AS trip_duration_mins,
    (tip_amount/NULLIF(fare_amount,0)) AS tip_percentage,
    EXTRACT(HOUR FROM pickup_dt AT TIME ZONE 'America/New_York') AS pickup_hour,
    FORMAT_TIMESTAMP('%A', pickup_dt, 'America/New_York') AS pickup_dow,
    (CASE WHEN fare_amount < 0 OR passenger_count <= 0 OR trip_distance <= 0 THEN TRUE
    ELSE FALSE END) AS is_likely_invalid
    FROM inter_trips_lookup
)

SELECT * FROM enriched_data