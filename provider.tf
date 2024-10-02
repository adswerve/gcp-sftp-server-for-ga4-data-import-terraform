terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=6.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 17.0"

  project_id = var.project_id
  activate_apis = var.gcp_service_list
  disable_services_on_destroy = false
}