/*Materialzied this model as table because if the model is saved as a view and if called/referred by any model
the values inside the foreign key column will change/updated during the call without updating the values in parimary key of
this model which causes the join to yeild no results 
*/
{{ config(materialized = "table") }}

WITH deduped_zone AS (
    SELECT DISTINCT zone AS zone, borough, service_zone
    FROM {{ref('stg_lookup')}}
),

uuid_data AS (
    SELECT {{dbt_utils.generate_surrogate_key(['zone','borough','service_zone'])}} AS id, *
    FROM deduped_zone
)

SELECT * FROM uuid_data