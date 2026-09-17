WITH trips_raw AS (
    SELECT * FROM {{source('raw_nyc_tlc','trips')}}
),

renamed AS (
    SELECT 
        vendorid AS vendor_id,
        DATE(tpep_pickup_datetime,'America/New_York') AS pickup_date,
        TIME(tpep_pickup_datetime,'America/New_York') AS pickup_time,
        DATE(tpep_dropoff_datetime,'America/New_York') AS dropoff_date,
        TIME(tpep_dropoff_datetime,'America/New_York') AS dropoff_time,
        passenger_count,
        trip_distance,
        pulocationid AS pickup_location_id,
        dolocationid AS dropoff_location_id,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount
    FROM trips_raw
)

SELECT * FROM renamed