from google.cloud import bigquery
client = bigquery.Client(project='analog-fastness-472715-j6')
q = 'SELECT COUNT(1) as cnt FROM `analog-fastness-472715-j6.customer_cdp.customer_target`'
print('Running:', q)
print(list(client.query(q).result())[0])
q2 = 'SELECT * FROM `analog-fastness-472715-j6.customer_cdp.customer_target` LIMIT 5'
for r in client.query(q2).result():
    print(dict(r))
