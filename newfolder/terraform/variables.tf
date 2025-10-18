variable "project" { type = string }
variable "region" { type = string }
variable "location" { type = string }
variable "dataset_fdp" { type = string }
variable "customer_project_table_name" { type = string }

# Example usage:
# terraform init
# terraform apply -var "project=analog-fastness-472715-j6" -var "region=asia-south1" -var "location=asia-south1" -var "dataset_fdp=customer_fdp" -var "customer_project_table_name=customer_project"
