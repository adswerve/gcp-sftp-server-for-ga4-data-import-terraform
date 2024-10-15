// GCP project information
project_id = "your-gcp-project-name-goes-here"

// Prefix for naming resources set up in GCP
// Use 6-30 characters matching RegEx `[a-z]([-a-z0-9]*[a-z0-9])`
name = "ga4-data-import-sftp"

// Custom hostname for SFTP server
server_hostname = "ga4sftp.example.com"

// Username for file uploader
username = "sftpuser"

// Google Compute Engine instance configuration settings
machine_type = "e2-micro"
os_family    = "ubuntu-2404-lts-amd64"
compute_region = "us-central1"
compute_zone = "us-central1-a"