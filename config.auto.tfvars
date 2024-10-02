// Prefix for naming resources set up in GCP
// Note: for best results, stick to 6-30 characters matching this RegEx: `[a-z]([-a-z0-9]*[a-z0-9])`
name = "ga4-data-import-sftp"

// GCP project information
project_id = "as-dev-ryan"

// Google Compute Engine instance configuration settings
machine_type = "e2-micro"
os_family    = "ubuntu-2404-lts-amd64"
compute_zone = "us-central1-a"

// Firewall configuration settings
firewall_ip_ranges = ["0.0.0.0/0"]