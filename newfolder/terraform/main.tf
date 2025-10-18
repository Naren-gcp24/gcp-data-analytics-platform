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

resource "google_bigquery_table" "customer_project_table" {
  dataset_id = var.dataset_fdp
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
