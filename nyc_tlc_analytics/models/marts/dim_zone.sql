WITH deduped_zone AS (
    SELECT DISTINCT zone AS zone, borough, service_zone
    FROM {{ref('stg_lookup')}}
),

uuid_data AS (
    SELECT *, GENERATE_UUID() AS id
    FROM deduped_zone
)

SELECT * FROM uuid_data