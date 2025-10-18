variable "project" {
  description = "GCP project id"
  type        = string
  default     = "analog-fastness-472715-j6"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-south1"
}

variable "location" {
  description = "BigQuery location"
  type        = string
  default     = "asia-south1"
}

variable "env" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "dataset_fdp" {
  description = "Dataset id for customer_fdp"
  type        = string
  default     = "customer_fdp"
}

variable "dataset_cdp" {
  description = "Dataset id for customer_cdp"
  type        = string
  default     = "customer_cdp"
}

variable "backup_bucket_name" {
  description = "Optional name for the GCS backup bucket. If empty, a default will be used: <project>-dbt-backup"
  type        = string
  default     = ""
}

variable "customer_cdp_bucket_name" {
  description = "Optional name for the customer_cdp GCS bucket. If empty, defaults to <project>-customer-cdp"
  type        = string
  default     = ""
}

variable "customer_fdp_table_name" {
  description = "Name of the BigQuery table to create in the customer_fdp dataset"
  type        = string
  default     = "customer_info"
}

variable "customer_project_table_name" {
  description = "Name of the BigQuery table to create in the customer_fdp dataset for project usage"
  type        = string
  default     = "customer_project"
}

variable "customer_cdp_table_name" {
  description = "Name of the BigQuery table to create in the customer_cdp dataset"
  type        = string
  default     = "customer_target"
}
