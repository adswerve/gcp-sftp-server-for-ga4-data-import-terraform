terraform {
  backend "gcs" {
    bucket = "ga4-data-import-sftp-tf-state"
    prefix = "dev"
  }
}