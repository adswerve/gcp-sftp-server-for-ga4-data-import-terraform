variable "name" {
  description = "Prefix for naming resources set up in GCP"
  type        = string
}

// Authentication Variables
// See article for using Terraform environment variables:
// https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1
variable "username" {
  description = "The username for the SFTP server user"
  type        = string
  sensitive   = true
}

// General GCP Variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_service_list" {
    description = "GCP API libraries to enable, if necessary"
    type = list(string)
    default = [
        "cloudresourcemanager.googleapis.com",
        "serviceusage.googleapis.com",
        "compute.googleapis.com",
        "iam.googleapis.com",
        "storage.googleapis.com"
    ]
}

// Compute Engine Variables
variable "machine_type" {
  description = "Series and type of machine used for Compute Engine"
  type        = string
}

variable "os_family" {
  description = "Image project and/or family for OS for boot disk on Compute Engine"
  type        = string
}

variable "compute_region" {
  description = "The region for the machine instance, used for the static IP address"
  type        = string
}

variable "compute_zone" {
  description = "The zone that the machine instance should be created in"
  type        = string
}

variable "server_hostname" {
  description = "The custom domain used for accessing the machine instance"
}

variable "firewall_ip_ranges" {
  description = "The range of IP addresses that are allowed to connect to your VM"
  type        = list(string)
  default = ["0.0.0.0/0"]
}