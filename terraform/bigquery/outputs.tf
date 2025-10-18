output "dataset_fdp_id" {
  value = google_bigquery_dataset.customer_fdp.dataset_id
}

output "backup_bucket_name" {
  value = google_storage_bucket.backup.name
}

output "customer_cdp_bucket_name" {
  value = google_storage_bucket.customer_cdp_bucket.name
}

output "customer_fdp_table_id" {
  value = google_bigquery_table.customer_fdp_table.table_id
}

output "customer_cdp_table_id" {
  value = google_bigquery_table.customer_cdp_table.table_id
}

output "dataset_cdp_id" {
  value = google_bigquery_dataset.customer_cdp.dataset_id
}

output "customer_project_table_id" {
  value = google_bigquery_table.customer_fdp_project_table.table_id
}
