WITH date_spine AS (
    {{dbt_utils.date_spine(
        start_date = "CAST('2025-12-31' AS DATE)",
        end_date = "CAST('2026-04-01' AS DATE)",
        datepart = "day"
    )}}
),

uuid_date AS (
    SELECT date_day,
    TIMESTAMP(date_day, 'America/New_York') AS date_utc_sod,
    FROM date_spine
)

SELECT GENERATE_UUID() AS id, *, TIMESTAMP_ADD(date_utc_sod, INTERVAL 86399 SECOND) AS date_utc_eod,
EXTRACT(YEAR FROM date_utc_sod AT TIME ZONE 'America/New_York') AS year,
EXTRACT(MONTH FROM date_utc_sod AT TIME ZONE 'America/New_York') AS month,
EXTRACT(DAY FROM date_utc_sod AT TIME ZONE 'America/New_York') AS day,
FORMAT_TIMESTAMP('%A',date_utc_sod, 'America/New_York') AS dow,
(CASE
    WHEN EXTRACT(DAYOFWEEK FROM date_utc_sod AT TIME ZONE 'America/New_York') IN (1,7) THEN 'Weekend'
    ELSE 'Weekday'
END) AS is_weekday
FROM uuid_date
ORDER BY date_utc_sod