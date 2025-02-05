terraform {
  backend "gcs" {
    bucket = ""
    prefix = "dev"
  }
}