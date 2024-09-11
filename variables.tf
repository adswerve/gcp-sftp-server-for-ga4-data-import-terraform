variable "name" {
    description = "Prefix for naming resources set up in GCP"
    type = string
}

// See article for using Terraform environment variables:
// https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1
variable "username" {
    description = "The username for the SFTP server user"
    type = string
    sensitive = true
}

variable "password" {
    description = "The password for the SFTP server user"
    type = string
    sensitive = true
}

variable "project_id" {
    description = "GCP Project ID"
    type = string
}

variable "machine_type" {
    description = "Series and type of machine used for Compute Engine"
    type = string
}

variable "os_family" {
    description = "Image project and/or family for OS for boot disk on Compute Engine"
    type = string
}

variable "firewall_ip_ranges" {
  description = "The range of IP addresses that are allowed to connect to your VM"
  type = list(string)
}