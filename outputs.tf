output "sftp_server_ip" {
  value       = google_compute_address.sftp_static_ip.address
  description = "SFTP Server IPv4 Address"
}