from google.cloud import bigquery
client = bigquery.Client(project='analog-fastness-472715-j6')
queries = [
    'SELECT COUNT(1) as cnt FROM `analog-fastness-472715-j6.customer_cdp.customer_target`',
    'SELECT COUNT(1) as cnt FROM `analog-fastness-472715-j6.dbt_projects.customer_target`',
    'SELECT COUNT(1) as cnt FROM `analog-fastness-472715-j6.dbt_projects_customer_cdp.customer_target`',
]
for q in queries:
    try:
        r = list(client.query(q).result())[0]
        print(q, '->', r.cnt)
    except Exception as e:
        print(q, '-> error', e)
