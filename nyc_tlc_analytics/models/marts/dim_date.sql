WITH date_spine AS (
    {{dbt_utils.date_spine(
        start_date = "CAST('2026-01-01' AS DATE)",
        end_date = "CAST('2026-04-01' AS DATE)",
        datepart = "day"
    )}}
),

uuid_date AS (
    SELECT date_day,
    DATE(date_day) AS date_utc,
    FROM date_spine
)

SELECT GENERATE_UUID() AS id, *,
EXTRACT(YEAR FROM date_utc) AS year,
EXTRACT(MONTH FROM date_utc) AS month,
EXTRACT(DAY FROM date_utc) AS day,
FORMAT_DATE('%A',date_utc) AS dow,
EXTRACT(DAYOFWEEK FROM date_utc) AS dow_num,
(CASE
    WHEN EXTRACT(DAYOFWEEK FROM date_utc) IN (1,7) THEN 'Weekend'
    ELSE 'Weekday'
END) AS is_weekend
FROM uuid_date
ORDER BY date_utc