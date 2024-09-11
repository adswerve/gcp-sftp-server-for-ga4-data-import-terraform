# GCP SFTP Server for GA4 Data Import
## SFTP Credentials
Prior to running the `terraform plan` or `terraform apply` commands for the first time, add username and password as environment variables:
`export TF_VAR_username='myusername'`
`export TF_VAR_password='mypassword'`

## TODO:
- write documentation
- add secret manager and service account support for better management of username/password
- update shell script in startup to pull username/password from secret manager
- test personal connection to sftp server
- test connecting sftp to GA4 data import