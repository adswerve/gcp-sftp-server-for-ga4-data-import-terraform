terraform {
  backend "gcs" {
    bucket = "${var.project_id}-ga4-data-import-sftp-tf-state"
    prefix = "dev"
  }
}