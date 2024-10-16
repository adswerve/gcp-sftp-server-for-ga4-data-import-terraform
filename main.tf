// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "sftp_static_ip" {
  name = "${var.name}-static-ip"
  region = var.compute_region
  //purpose = "GCE_ENDPOINT"
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "sftp_server" {
  name         = "${var.name}-server"
  machine_type = var.machine_type
  zone         = var.compute_zone

  boot_disk {
    initialize_params {
      image = var.os_family
    }
  }

  hostname = var.server_hostname

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.sftp_static_ip.address
    }
  }

  // https://developer.hashicorp.com/terraform/language/functions/templatefile
  metadata_startup_script = templatefile("./startup.sh", {
    username_sftp = var.username,
    public_key_ga4 = trimspace(file("${path.module}/ga4_sftp.pub")),
    public_key_sftp = trimspace(file("${path.module}/id_sftp.pub")),
    gcs_bucket = google_storage_bucket.file_bucket.name
  })

  service_account {
    email = google_service_account.compute_engine_sa.email
    scopes = ["cloud-platform", "storage-rw"]
  }

  tags = ["ga4-sftp-server"]
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow-sftp" {
  name    = "${var.name}-allow-sftp"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.firewall_ip_ranges
  target_tags   = ["ga4-sftp-server"]
}