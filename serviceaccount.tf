// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
// Create a service account for Compute Engine to use with Cloud Storage
resource "google_service_account" "compute_engine_sa" {
  account_id                   = var.name
  display_name                 = "GA4 Data Import SFTP"
  description                  = "Service account for GA4 Data Import on Compute Engine SFTP server"
  create_ignore_already_exists = true

  depends_on = [module.project-services]
}

// Grant bucket permissions to the Compute Engine service account
resource "google_storage_bucket_iam_member" "compute_engine_access" {
  bucket = google_storage_bucket.file_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.compute_engine_sa.email}"

  depends_on = [module.project-services]
}