Terraform BigQuery datasets

This folder contains a small Terraform configuration to create two BigQuery
datasets in a GCP project:

- `customer_fdp`
- `customer_cdp`

Prerequisites
- Terraform >= 1.0.0 installed
- A GCP service account with permissions to create BigQuery datasets, and
  credentials JSON available (or `gcloud` authenticated user)


# Quick start (PowerShell)

The Terraform defaults in this folder are already set to:

- project: analog-fastness-472715-j6
- location/region: asia-south1

If you have a service account JSON, set the environment variable and run:

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS = 'C:\path\to\service-account.json'

cd terraform\bigquery
terraform init
terraform apply -auto-approve
```

If you prefer to override the project on the command line:

```powershell
terraform apply -var="project=other-project-id" -auto-approve
```

This will create the two datasets (`customer_fdp`, `customer_cdp`) in the specified project and location.
