SELECT 'Average Speed (mph)' AS metric,
AVG(CASE WHEN pickup_borough = 'Manhattan' THEN avg_speed_mph END) AS manhattan,
AVG(CASE WHEN pickup_borough = 'Bronx' THEN avg_speed_mph END) AS bronx,
AVG(CASE WHEN pickup_borough = 'Queens' THEN avg_speed_mph END) AS queens,
AVG(CASE WHEN pickup_borough = 'Brooklyn' THEN avg_speed_mph END) AS brooklyn,
AVG(CASE WHEN pickup_borough = 'Staten Island' THEN avg_speed_mph END) AS staten_island,
AVG(CASE WHEN pickup_borough = 'EWR' THEN avg_speed_mph END) AS ewr,
AVG(CASE WHEN pickup_borough = 'N/A' THEN avg_speed_mph END) AS n_a,
AVG(CASE WHEN pickup_borough = 'Unknown' THEN avg_speed_mph END) AS unknown
FROM {{ ref('mart_borough_equity') }}
UNION ALL
SELECT 'Average Trip Distance' AS metric,
AVG(CASE WHEN pickup_borough = 'Manhattan' THEN avg_distance END) AS manhattan,
AVG(CASE WHEN pickup_borough = 'Bronx' THEN avg_distance END) AS bronx,
AVG(CASE WHEN pickup_borough = 'Queens' THEN avg_distance END) AS queens,
AVG(CASE WHEN pickup_borough = 'Brooklyn' THEN avg_distance END) AS brooklyn,
AVG(CASE WHEN pickup_borough = 'Staten Island' THEN avg_distance END) AS staten_island,
AVG(CASE WHEN pickup_borough = 'EWR' THEN avg_distance END) AS ewr,
AVG(CASE WHEN pickup_borough = 'N/A' THEN avg_distance END) AS n_a,
AVG(CASE WHEN pickup_borough = 'Unknown' THEN avg_distance END) AS unknown
FROM {{ ref('mart_borough_equity') }}
UNION ALL
SELECT 'Average Fare ($)' AS metric,
AVG(CASE WHEN pickup_borough = 'Manhattan' THEN avg_fare END) AS manhattan,
AVG(CASE WHEN pickup_borough = 'Bronx' THEN avg_fare END) AS bronx,
AVG(CASE WHEN pickup_borough = 'Queens' THEN avg_fare END) AS queens,
AVG(CASE WHEN pickup_borough = 'Brooklyn' THEN avg_fare END) AS brooklyn,
AVG(CASE WHEN pickup_borough = 'Staten Island' THEN avg_fare END) AS staten_island,
AVG(CASE WHEN pickup_borough = 'EWR' THEN avg_fare END) AS ewr,
AVG(CASE WHEN pickup_borough = 'N/A' THEN avg_fare END) AS n_a,
AVG(CASE WHEN pickup_borough = 'Unknown' THEN avg_fare END) AS unknown
FROM {{ ref('mart_borough_equity') }}
UNION ALL
SELECT 'Average Tip %' AS metric,
AVG(CASE WHEN pickup_borough = 'Manhattan' THEN avg_tip_pct_card_only END) AS manhattan,
AVG(CASE WHEN pickup_borough = 'Bronx' THEN avg_tip_pct_card_only END) AS bronx,
AVG(CASE WHEN pickup_borough = 'Queens' THEN avg_tip_pct_card_only END) AS queens,
AVG(CASE WHEN pickup_borough = 'Brooklyn' THEN avg_tip_pct_card_only END) AS brooklyn,
AVG(CASE WHEN pickup_borough = 'Staten Island' THEN avg_tip_pct_card_only END) AS staten_island,
AVG(CASE WHEN pickup_borough = 'EWR' THEN avg_tip_pct_card_only END) AS ewr,
AVG(CASE WHEN pickup_borough = 'N/A' THEN avg_tip_pct_card_only END) AS n_a,
AVG(CASE WHEN pickup_borough = 'Unknown' THEN avg_tip_pct_card_only END) AS unknown
FROM {{ ref('mart_borough_equity') }}