from google.cloud import bigquery
bigquery.Client(project = "nyc-tlc-analytics-506407").query("SELECT 1").result()