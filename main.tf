// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "sftp_server" {
  name = "${var.name}-server"
  machine_type = var.machine_type
  zone = var.compute_zone

  boot_disk {
    initialize_params {
      image = var.os_family
    }
  }

  network_interface {
    network = "default"
    access_config {
      
    }
  }

  // https://developer.hashicorp.com/terraform/language/functions/templatefile
  metadata_startup_script = templatefile("./startup.sh", {username = var.username, password=var.password})

  tags = ["ga4-sftp-server"]
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow-sftp" {
    name = "${var.name}-allow-sftp"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["22"]
    }

    source_ranges = var.firewall_ip_ranges
    target_tags = ["ga4-sftp-server"]
}