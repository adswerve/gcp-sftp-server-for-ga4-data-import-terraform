// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "file_bucket" {
  name          = "${var.project_id}-${var.name}"
  location      = "US"
  force_destroy = true

  autoclass {
    enabled = true
  }

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  depends_on = [module.project-services]
}