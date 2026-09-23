SELECT 'Invalid/Faulty data' AS data_quality_tag, COUNT(*) AS count_records
FROM {{ ref('fct_trips') }}
WHERE is_likely_invalid = true
GROUP BY data_quality_tag
UNION ALL
SELECT 'Accurate data' AS data_quality_tag, COUNT(*) AS count_records
FROM {{ ref('fct_trips') }}
WHERE is_likely_invalid = false
GROUP BY data_quality_tag