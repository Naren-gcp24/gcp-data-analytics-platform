#!/usr/bin/env python3
"""Load a CSV from a GCS bucket into a BigQuery table.
Usage: python load_gcs_to_bq.py gs://bucket/path/to/file.csv project dataset table
"""
import sys
from google.cloud import bigquery

if len(sys.argv) != 5:
    print("Usage: python load_gcs_to_bq.py gs://bucket/path file project dataset table")
    sys.exit(2)

gcs_uri = sys.argv[1]
project = sys.argv[2]
dataset = sys.argv[3]
table = sys.argv[4]

client = bigquery.Client(project=project)

destination = f"{project}.{dataset}.{table}"
print(f"Loading {gcs_uri} into {destination}")

job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV,
    skip_leading_rows=1,
    autodetect=False,
    write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
    field_delimiter=",",
)

# Define schema explicitly to match table definition
job_config.schema = [
    bigquery.SchemaField("CustomerID", "INTEGER"),
    bigquery.SchemaField("CustomerName", "STRING"),
    bigquery.SchemaField("Email", "STRING"),
    bigquery.SchemaField("PhoneNumber", "STRING"),
    bigquery.SchemaField("Location", "STRING"),
    bigquery.SchemaField("Country", "STRING"),
    bigquery.SchemaField("JoinDate", "DATE"),
    bigquery.SchemaField("LastPurchaseDate", "DATE"),
    bigquery.SchemaField("TotalSpent", "FLOAT"),
    bigquery.SchemaField("LoyaltyPoints", "INTEGER"),
]

uri = gcs_uri

load_job = client.load_table_from_uri(uri, destination, job_config=job_config)
print("Job started...")
load_job.result()  # wait for completion

print(f"Loaded {load_job.output_rows} rows into {destination}")
