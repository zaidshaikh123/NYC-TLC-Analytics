WITH deduped_zone AS (
    SELECT DISTINCT zone AS zone, borough, service_zone
    FROM {{ref('stg_lookup')}}
),

uuid_data AS (
    SELECT {{dbt_utils.generate_surrogate_key(['zone','borough','service_zone'])}} AS id, *
    FROM deduped_zone
)

SELECT * FROM uuid_data