from pathlib import Path
from google.cloud import bigquery
from google.cloud.exceptions import NotFound

client = bigquery.Client(project = "nyc-tlc-analytics-506407")
dataset_id = "nyc_tlc_raw"
table_id = f"{dataset_id}.trips"

query = """SELECT FORMAT_TIMESTAMP( '%Y-%m', tpep_pickup_datetime) AS pickup_month,
COUNT(*) AS total_records
FROM `nyc-tlc-analytics-506407.nyc_tlc_raw.trips`
GROUP BY pickup_month
ORDER BY pickup_month"""

dataset_ref = bigquery.DatasetReference(client.project, dataset_id)

try:
    client.get_dataset(dataset_ref)
except NotFound:
    dataset = bigquery.Dataset(dataset_ref)
    dataset.location = "US"
    client.create_dataset(dataset)
    print(f"Created Dataset: {dataset_id}")

job_config = bigquery.LoadJobConfig(
    source_format = bigquery.SourceFormat.PARQUET,
    write_disposition = bigquery.WriteDisposition.WRITE_APPEND,
    schema_update_options = [bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION]
)

get_dir = Path("data/raw/")
file_list = [f for f in get_dir.iterdir() if f.is_file()]

for get_file in file_list:
    with open(get_file, 'rb') as f:
        job = client.load_table_from_file(f, table_id, job_config = job_config)
    job.result()
    print(f"Loaded {client.get_table(table_id).num_rows} rows")

query_job = client.query(query)
results = query_job.result()

for row in results:
    print(f"{row.pickup_month}: {row.total_records}")