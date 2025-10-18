CI guide

1. Add a Jenkins credential with ID `gcr-service-account-key` containing the GCP service account JSON.
2. Jenkinsfile will build the loader image and push to GCR: `gcr.io/<PROJECT>/customer-loader:<BUILD_NUMBER>`
3. The loader image uses `GCP_PROJECT`, `GCP_DATASET`, `GCP_TABLE` environment variables to know where to insert rows.

Local test

```
cd scripts/loader
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python app.py
```
