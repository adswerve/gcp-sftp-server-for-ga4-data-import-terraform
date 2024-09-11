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

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y openssh-server

    # Assign environment variables to local shell variables
    username = "${var.username}"
    password = "${var.password}"

    # Add user and set password
    sudo adduser --comment "" --disabled-password "$username"
    echo "$username:$password" | sudo chpasswd

    # Set up SFTP directories and permissions
    sudo mkdir -p /var/sftp/uploads
    sudo chown root:root /var/sftp
    sudo chmod 755 /var/sftp
    sudo chown "$username:$username" /var/sftp/uploads

    # Configure SSH server for SFTP
    sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOT
    Match User $username
    ForceCommand internal-sftp
    PasswordAuthentication yes
    ChrootDirectory /var/sftp
    PermitTunnel no
    AllowAgentForwarding no
    AllowTcpForwarding no
    X11Forwarding no
    EOT

    # Restart SSH service to apply changes
    sudo systemctl restart sshd
  EOF

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