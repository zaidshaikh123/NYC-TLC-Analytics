WITH raw_lookup AS (
    SELECT * FROM {{ source('raw_nyc_tlc','taxi_zone_lookup') }}
),

lookup_renamed AS (
    SELECT locationid AS location_id, borough, zone, service_zone
    FROM raw_lookup
)

SELECT * FROM lookup_renamed