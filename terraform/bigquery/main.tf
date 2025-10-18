terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "google" {
  project = var.project
  region  = var.region
}

# BigQuery datasets
resource "google_bigquery_dataset" "customer_fdp" {
  dataset_id = var.dataset_fdp
  project    = var.project
  location   = var.location
  description = "Foundation Data Platform dataset for customer (customer_fdp)"
  labels = {
    created_by = "terraform"
    env        = var.env
  }
}

resource "google_bigquery_dataset" "customer_cdp" {
  dataset_id = var.dataset_cdp
  project    = var.project
  location   = var.location
  description = "Customer Data Platform dataset (customer_cdp)"
  labels = {
    created_by = "terraform"
    env        = var.env
  }
}

# Optional backup bucket for dataset exports, in same location
locals {
  bucket_name = (var.backup_bucket_name != "" ? var.backup_bucket_name : "${var.project}-dbt-backup")
}

resource "google_storage_bucket" "backup" {
  name     = local.bucket_name
  location = var.location
  project  = var.project

  uniform_bucket_level_access = true

  labels = {
    created_by = "terraform"
    env        = var.env
  }
}

locals {
  customer_cdp_bucket = (var.customer_cdp_bucket_name != "" ? var.customer_cdp_bucket_name : "${var.project}-customer-cdp")
}

resource "google_storage_bucket" "customer_cdp_bucket" {
  name     = local.customer_cdp_bucket
  location = var.location
  project  = var.project

  uniform_bucket_level_access = true

  labels = {
    created_by = "terraform"
    env        = var.env
  }
}

# Create a BigQuery table in customer_fdp for customer information
resource "google_bigquery_table" "customer_fdp_table" {
  dataset_id = google_bigquery_dataset.customer_fdp.dataset_id
  table_id   = var.customer_fdp_table_name
  project    = var.project

  schema = jsonencode([
    { "name":"CustomerID", "type":"INTEGER", "mode":"REQUIRED" },
    { "name":"CustomerName", "type":"STRING", "mode":"NULLABLE" },
    { "name":"Email", "type":"STRING", "mode":"NULLABLE" },
    { "name":"PhoneNumber", "type":"STRING", "mode":"NULLABLE" },
    { "name":"Location", "type":"STRING", "mode":"NULLABLE" },
    { "name":"Country", "type":"STRING", "mode":"NULLABLE" },
    { "name":"JoinDate", "type":"DATE", "mode":"NULLABLE" },
    { "name":"LastPurchaseDate", "type":"DATE", "mode":"NULLABLE" },
    { "name":"TotalSpent", "type":"FLOAT", "mode":"NULLABLE" },
    { "name":"LoyaltyPoints", "type":"INTEGER", "mode":"NULLABLE" }
  ])
  
  lifecycle {
    # Avoid destructive replacements of the existing foundation table when
    # schema drift is detected outside Terraform. We only want to manage the
    # existence of the resource here, not force schema rewrites.
    ignore_changes = [schema]
  }
}

# BigQuery table in customer_cdp that will hold the transformed/target data
resource "google_bigquery_table" "customer_cdp_table" {
  dataset_id = google_bigquery_dataset.customer_cdp.dataset_id
  table_id   = var.customer_cdp_table_name
  project    = var.project

  # Schema chosen to be compatible with the source customer_info; adjust as needed
  schema = jsonencode([
    { "name":"customer_id", "type":"INTEGER", "mode":"REQUIRED" },
    { "name":"sname", "type":"STRING", "mode":"NULLABLE" },
    { "name":"location", "type":"STRING", "mode":"NULLABLE" },
    { "name":"sal", "type":"FLOAT", "mode":"NULLABLE" },
    { "name":"email", "type":"STRING", "mode":"NULLABLE" },
    { "name":"signup_date", "type":"DATE", "mode":"NULLABLE" },
    { "name":"status", "type":"STRING", "mode":"NULLABLE" },
    { "name":"loyalty_score", "type":"FLOAT", "mode":"NULLABLE" }
  ])
}

# BigQuery table for customer_project under customer_fdp used by CI/demo
resource "google_bigquery_table" "customer_fdp_project_table" {
  dataset_id = google_bigquery_dataset.customer_fdp.dataset_id
  table_id   = var.customer_project_table_name
  project    = var.project

  schema = jsonencode([
    { "name":"customer_id", "type":"INT64", "mode":"REQUIRED" },
    { "name":"customer_name", "type":"STRING", "mode":"NULLABLE" },
    { "name":"location", "type":"STRING", "mode":"NULLABLE" },
    { "name":"email", "type":"STRING", "mode":"NULLABLE" },
    { "name":"phone", "type":"STRING", "mode":"NULLABLE" },
    { "name":"join_date", "type":"DATE", "mode":"NULLABLE" },
    { "name":"status", "type":"STRING", "mode":"NULLABLE" },
    { "name":"loyalty_score", "type":"FLOAT", "mode":"NULLABLE" }
  ])

  lifecycle {
    ignore_changes = [schema]
  }
}
