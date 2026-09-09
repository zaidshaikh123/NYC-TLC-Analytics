WITH date_spine AS (
    {{dbt_utils.date_spine(
        start_date = "CAST('2026-01-01' AS date)",
        end_date = "CAST('2026-03-31' AS date)",
        datepart = "day"
    )}}
),

uuid_date AS (
    SELECT GENERATE_UUID() AS id, TIMESTAMP(date_day, 'America/New_York') AS date_utc
    FROM date_spine
)

SELECT *,
EXTRACT(YEAR FROM date_utc AT TIME ZONE 'America/New_York') AS date_year,
EXTRACT(MONTH FROM date_utc AT TIME ZONE 'America/New_York') AS date_month,
EXTRACT(DAY FROM date_utc AT TIME ZONE 'America/New_York') AS date_day,
FORMAT_TIMESTAMP('%A',date_utc, 'America/New_York') AS date_dow,
(CASE
    WHEN EXTRACT(DAYOFWEEK FROM date_utc AT TIME ZONE 'America/New_York') IN (1,7) THEN 'Weekend'
    ELSE 'Weekday'
END) AS is_weekday
FROM uuid_date