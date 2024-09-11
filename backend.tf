terraform {
  backend "gcs" {
    bucket = "${var.name}-tf-state"
    prefix = "dev"
  }
}