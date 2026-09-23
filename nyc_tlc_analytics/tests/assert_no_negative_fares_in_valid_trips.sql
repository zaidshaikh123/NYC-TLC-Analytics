SELECT *
FROM {{ ref('fct_trips') }}
WHERE fare_amount < 0 AND NOT is_likely_invalid