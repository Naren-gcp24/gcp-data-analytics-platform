from google.cloud import bigquery
import os

def load_sample_rows(project, dataset, table):
    client = bigquery.Client(project=project)
    table_id = f"{project}.{dataset}.{table}"
    rows = [
        {"customer_id": 1, "customer_name": "Alice", "location": "Delhi", "email": "alice@example.com", "phone": "+911234567890", "join_date": "2025-01-01", "status": "active", "loyalty_score": 10.5},
        {"customer_id": 2, "customer_name": "Bob", "location": "Mumbai", "email": "bob@example.com", "phone": "+911098765432", "join_date": "2025-02-15", "status": "active", "loyalty_score": 8.0}
    ]
    errors = client.insert_rows_json(table_id, rows)
    if errors:
        print('Errors:', errors)
    else:
        print(f'Inserted {len(rows)} rows into {table_id}')

if __name__ == '__main__':
    project = os.environ.get('GCP_PROJECT', 'analog-fastness-472715-j6')
    dataset = os.environ.get('GCP_DATASET', 'customer_fdp')
    table = os.environ.get('GCP_TABLE', 'customer_project')
    load_sample_rows(project, dataset, table)
