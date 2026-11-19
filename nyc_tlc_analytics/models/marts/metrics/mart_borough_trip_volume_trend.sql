WITH refer_borough_equity AS (SELECT pickup_borough, pickup_month, trip_count, LAG(trip_count) OVER(PARTITION BY pickup_borough ORDER BY pickup_month) AS lag_trip_count
FROM {{ ref('mart_borough_equity') }}
ORDER BY pickup_borough, pickup_month),

trend AS (SELECT *, COALESCE(((trip_count - lag_trip_count)/lag_trip_count)*100,0) AS trip_volumne_trend_pct
FROM refer_borough_equity)

SELECT * FROM trend
/*Might be unnecessary to pivot the data, just a simple select from mart_borough_equity can do the trick
SELECT pickup_borough,
{{
    dbt_utils.pivot(
        column = 'pickup_month',
        values = dbt_utils.get_column_values(ref('mart_borough_equity'), 'pickup_month'),
        agg = 'max',
        then_value = 'trip_count',
        else_value = 'null'
    )
}}
FROM {{ ref('mart_borough_equity') }}
GROUP BY pickup_borough*/
