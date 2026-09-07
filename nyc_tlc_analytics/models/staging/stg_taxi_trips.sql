WITH trips_raw AS (
    SELECT * FROM {{source('raw_nyc_tlc','trips')}}
),

renamed AS (
    SELECT 
        vendorid AS vendor_id,
        tpep_pickup_datetime AS pickup_dt,
        tpep_dropoff_datetime AS dropoff_dt,
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