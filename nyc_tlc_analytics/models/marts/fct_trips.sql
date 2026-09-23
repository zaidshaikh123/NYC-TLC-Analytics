WITH trips_enriched AS (
    SELECT * FROM {{ref('interim_trips_enriched')}}
),

date_enriched AS (
    SELECT * FROM {{ref('dim_date')}}
),

zone_data AS (
    SELECT * FROM {{ref('dim_zone')}}
),

trip_x_date AS (
    SELECT t.*, d1.id AS pickup_date_uid, d2.id AS dropoff_date_uid
    FROM trips_enriched AS t INNER JOIN date_enriched AS d1
    ON t.pickup_date = d1.date_utc
    INNER JOIN date_enriched AS d2
    ON t.dropoff_date = d2.date_utc
),

trip_x_zone AS (
    SELECT t.*, z1.id AS pickup_location_uid, z2.id AS dropoff_location_uid
    FROM trip_x_date AS t INNER JOIN zone_data AS z1
    ON t.pickup_zone = z1.zone AND t.pickup_borough = z1.borough AND t.pickup_service_zone = z1.service_zone
    INNER JOIN zone_data AS z2
    ON t.dropoff_zone = z2.zone AND t.dropoff_borough = z2.borough AND t.dropoff_service_zone = z2.service_zone
),

fct_data AS (
    SELECT GENERATE_UUID() AS trip_id,
    vendor_id, pickup_date_uid, pickup_time, dropoff_date_uid, dropoff_time, passenger_count, trip_distance,
    pickup_location_uid, dropoff_location_uid, payment_type, fare_amount, extra,
    mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, trip_duration_mins,
    tip_percentage, pickup_hour, is_likely_invalid
    FROM trip_x_zone
)

SELECT * FROM fct_data