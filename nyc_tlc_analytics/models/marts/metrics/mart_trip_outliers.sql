SELECT *
FROM {{ ref('fct_trips') }}
WHERE is_likely_invalid IS TRUE