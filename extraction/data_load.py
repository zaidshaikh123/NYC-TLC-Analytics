from pathlib import Path
from google.cloud import bigquery
from google.cloud.exceptions import NotFound

client = bigquery.Client(project = "<project_id from Google BigQuery>")
dataset_id = "<dataset name of your choice>"
table_id = f"{dataset_id}.<table name of your choice>"

query = """SELECT FORMAT_TIMESTAMP( '%Y-%m', tpep_pickup_datetime) AS pickup_month,
COUNT(*) AS total_records
FROM `<project_id>.<dataset name>.<table name>`
GROUP BY pickup_month
ORDER BY pickup_month"""

#First check if dataset exists in BogQuery Project to which you wstablished connection with, if not then create the dataset
dataset_ref = bigquery.DatasetReference(client.project, dataset_id)

try:
    client.get_dataset(dataset_ref)
except NotFound:
    dataset = bigquery.Dataset(dataset_ref)
    dataset.location = "US"
    client.create_dataset(dataset)
    print(f"Created Dataset: {dataset_id}")

'''
    Set Job Configuration to Load Data to BigQuery to specifiy the format of incoming data,
    method of writing data i.e. WRITE_TRUNCATE to remove the old data in the table and then add new data OR WRITE_APPEND to simply append data
    and specifying schema options to allow new fields to be added if the next file contains a couple of more colunms that were not present in previous file when loading the data to table
'''
job_config = bigquery.LoadJobConfig(
    source_format = bigquery.SourceFormat.PARQUET,
    write_disposition = bigquery.WriteDisposition.WRITE_APPEND,
    schema_update_options = [bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION]
)

'''
    Get the list of file paths, iterate through them and load the data from the files to the table with the specifed job confguraton.
    Get the total number of cumulative records per data load from each file to the specified destination in BigQuery
'''
get_dir = Path("data/raw/")
file_list = [f for f in get_dir.iterdir() if f.is_file()]


for get_file in file_list:
    with open(get_file, 'rb') as f:
        job = client.load_table_from_file(f, table_id, job_config = job_config)
    job.result()
    print(f"Loaded {client.get_table(table_id).num_rows} rows")


'''
    Cross check the result from above by query the data loaded into the trips table to get the count of records per month
'''
query_job = client.query(query)
results = query_job.result()

for row in results:
    print(f"{row.pickup_month}: {row.total_records}")
