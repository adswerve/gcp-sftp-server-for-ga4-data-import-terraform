# GCP SFTP Server for GA4 Data Import
## SFTP Credentials
Prior to running the `terraform plan` or `terraform apply` commands for the first time, add username as an environment variable:
`export TF_VAR_username='myusername'`

2 users will be given access to the SFTP server: one for GA4 and one for the user managing/uploading files. Both will authenticate using a public key instead of a password, so 2 .pub files will need to be added to the Terraform folder prior to running. (Note: `.gitignore` has been set to ignore these files):
- "ga4_service_account_key.pub" (for the GA4 user)
- "id_rsa_sftp.pub" (for the file managing user)

## TODO:
- add Service Account for connecting to Cloud Storage
- make sure there's a variable for passing in GCS bucket name
- make sure key authentication works for GA4 and for end user
- write documentation

### Scratchpad:
- add secret manager and service account support for better management of username/password
- update shell script in startup to pull username/password from secret manager
- test personal connection to sftp server
- test connecting sftp to GA4 data import
- add Cloud Storage as a component for retaining the files