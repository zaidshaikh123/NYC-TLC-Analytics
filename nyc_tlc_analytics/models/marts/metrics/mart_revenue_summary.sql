WITH invalid_inclusive_sum AS (SELECT month, borough, payment_type, SUM(total_amount) AS total_amount_invalid_inclusive
FROM {{ ref('fct_trips') }} AS ft INNER JOIN {{ ref('dim_date') }} AS dd
ON ft.pickup_date_uid = dd.id
INNER JOIN {{ ref('dim_zone') }} AS dz
ON ft.pickup_location_uid = dz.id
GROUP BY month, borough, payment_type
ORDER BY month, total_amount_invalid_inclusive DESC),

invalid_exclusive_sum AS (SELECT month, borough, payment_type, SUM(total_amount) AS total_amount_invalid_exclusive
FROM {{ ref('fct_trips') }} AS ft INNER JOIN {{ ref('dim_date') }} AS dd
ON ft.pickup_date_uid = dd.id
INNER JOIN {{ ref('dim_zone') }} AS dz
ON ft.pickup_location_uid = dz.id
WHERE is_likely_invalid = false
GROUP BY month, borough, payment_type
ORDER BY month, total_amount_invalid_exclusive DESC)

SELECT iis.month, iis.borough, iis.payment_type,
iis.total_amount_invalid_inclusive, ies.total_amount_invalid_exclusive
FROM invalid_inclusive_sum AS iis INNER JOIN invalid_exclusive_sum AS ies
ON iis.month = ies.month AND iis.borough = ies.borough AND iis.payment_type = ies.payment_type