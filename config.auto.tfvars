// GCP project information
project_id = "as-dev-ryan"

// Prefix for naming resources set up in GCP
// Use 6-30 characters matching RegEx `[a-z]([-a-z0-9]*[a-z0-9])`
name = "ga4-data-import-sftp"

// Custom hostname for SFTP server
server_hostname = "ga4sftp.ptomey.net"

// Username for file uploader
username = "sftpuser"

// Google Compute Engine instance configuration settings
machine_type = "e2-micro"
os_family    = "ubuntu-2404-lts-amd64"
compute_region = "us-central1"
compute_zone = "us-central1-a"

// Assignment for public key files
//public_key_ga4 = file("ga4_service_account_key.pub")
//public_key_sftp = file("id_rsa_sftp.pub")