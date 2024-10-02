# GCP SFTP Server for GA4 Data Import
## Steps
1. Create a bucket in Google Cloud Storage for the Terraform state file named `ga4-data-import-sftp-tf-state`.
2. Choose a custom domain to use for the SFTP server.
3. Optionally, choose a username for the user who will be uploading and managing files. Otherwise, the default username of `sftpuser` will be used.
4. Generate a public key file for the user in step 3, name it `id_rsa_sftp.pub`, and save it within the parent folder of these scripts.
5. Create the SFTP data source in GA4's admin UI using the domain from step 2 plus the file path `/var/sftp/uploads/ga4data.csv`. The username for GA4 will be `ga4-importer`.
6. Get the public key file generated by GA4 following step 5, name it `ga4_service_account_key.pub`, and place it into the parent folder of these scripts.
7. Update the Configuration Settings (see details below) file.
8. In a terminal within this parent folder, run `terraform init` to complete the initial setup of Terraform.
9. In the same terminal, run `terraform plan` to validate the planned changes.
10. In the same terminal, run `terraform apply` and enter `yes` when prompted to complete the changes.
11. Once complete, Terraform will return an IPv4 address, which will need to be added to the DNS config for the domain chosen in step 2.
12. After the DNS configuration has been updated, you should be able to upload files to the SFTP server.

## Configuration Settings
The `config.auto.tfvars` file should be updated prior to running these Terraform scripts. See table below for details about each variable and whether it requires an update:
| **Variable** | **Update?** | **Description** |
|---|---|---|
| `project_id` | Required | The ID of the GCP project that will contain the SFTP server and its related infrastructure. |
| `name` | Optional | A string used when naming resources set up in GCP. Updating will be necessary if configuring multiple parallel SFTP servers in the same GCP project. |
| `server_hostname` | Required | The custom domain assigned to the SFTP server. Recommended format is `ga4sftp.<your website's eTLD+1>` |
| `username` | Optional | The username for the file uploader/manager accessing the SFTP server. |
| `machine_type` | Optional | The type of Compute Engine machine to use for the SFTP server. |
| `os_family` | Optional | The Operating System used by the virtual machine running the SFTP server. |
| `compute_region` | Optional | The region where the Compute Engine machine will run. Make sure that this is aligned with `compute_zone`. |
| `compute_zone` | Optional | The zone where the Compute Engine machine will run. Make sure that this is aligned with `compute_region`. |

## SFTP Authentication via Public Key
2 users will be given access to the SFTP server:
- one for GA4's data import connection
- one for the user managing/uploading files

Both users will authenticate using a public key instead of a password, so two `.pub` files will need to be added to the parent folder prior to running these Terraform scripts:
- "ga4_service_account_key.pub" (for the GA4 user)
- "id_rsa_sftp.pub" (for the file managing user)

Note: `.gitignore` has been set to ignore these files.

## TODO:
- make sure key authentication works for GA4 and for end user
- write documentation