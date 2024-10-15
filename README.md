# GCP SFTP Server for GA4 Data Import
## Description
This Terraform project is designed to simplify (where possible) the process of setting up an SFTP server on GCP. Once in place, the SFTP server can be used with GA4's Data Import function. Running these scripts will set up the server as a VM instance on Compute Engine, and the files will be stored in a Cloud Storage bucket. The server will also be provisioned with a service account to use when connecting with the GCS bucket.

## Prerequisites
The user running this Terraform file should have sufficient GCP permissions for managing Compute Engine and Cloud Storage as well as for creating service accounts.

The SFTP server will need a fixed hostname, so you will also need a domain and the ability to update its DNS configuration.

## Steps
1. Create a bucket in Google Cloud Storage for the Terraform state file named `ga4-data-import-sftp-tf-state`.
2. Choose a custom domain to use for the SFTP server.
3. Optionally, choose a username for the user who will be uploading and managing files. Otherwise, the default username of `sftpuser` will be used.
4. Generate a public key file for the user in step 3, name it `id_rsa_sftp.pub`, and save it within the parent folder of these scripts.
5. Create the SFTP data source in GA4's admin UI using the domain from step 2 plus the file path `/uploads/ga4data.csv`. The username for GA4 will be `ga4-importer`.
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

### Quick and Easy Key File Generation
Your device probably already has the OpenSSH version of `ssh-keygen` available, so follow these steps:
1. Open up a new Terminal.
2. Run the command `ssh-keygen`.
3. Press `Enter` to accept the default file location (`/Users/<username>/.ssh/`) or, optionally, input your own preferred location.
4. Optionally, input a password to encrypt the private key file or press `Enter` to skip this step. A second confirmation will be needed either way.
5. Find the private and public key files in the location from step 3.

Note: the file ending in `.pub` is the public key file that will be registered with the SFTP server. The other file is your private key that you will provide when authenticating with the server.

## Server Debugging Tips
If something goes wrong when setting up the SFTP server or trying to connect to it, you can get more information for debugging by connecting to the server and running some commands. You can easily connect to the server by logging in to GCP, then navigating to `Compute Engine > VM instances`. Find the instance with a name matching the `name` value set in your `config.auto.tfvars` file plus "-server", and click `SSH` toward the right side of the same row. Follow the prompts to open and authenticate via GCP's SSH-in-browser.

Once in a command line interface, you can:
* see the logs related to the startup script (see also the `startup.sh` file) by running: `sudo grep "startup-script" /var/log/syslog`
* check and monitor the authentication logs by running: `sudo tail -f /var/log/auth.log`
    * Note: stop monitoring the logs by pressing `Ctrl` + `c` on your keyboard.
* check the contents of the public key file by running: `sudo cat /home/<username>/.ssh/authorized_keys`
    * Note: replace `<username>` with the appropriate value (e.g., `sftpuser` for the default file managing user)

## FAQs
### Does the file for the Data Import have to be named `ga4data.csv`?
No, that value isn't hardcoded anywhere in these Terraform scripts. Just make sure that the file name matches what you've told GA4 to look for when configuring the Data Import data source.

### Do the public key files actually need to be named as prescribed?
Yes and no. The names are hardcoded, but if you really feel the need to change them, you can modify the file names being passed as options to `metadata_startup_script` in the `main.tf` file. However, it's not recommended to modify any of the `.tf` files or the `startup.sh` file.

### Can this support more than 1 data source/type in the Data Import settings?
Yes, it should be able to. Use a different file name when configuring the new data source in GA4, but keep the other details the same, including the username.

When GA4 returns the public key, it should match what you already have saved in the file `ga4_service_account_key.pub`. Compare the two values to confirm this.

### How do I connect to the SFTP server and upload files?
While not strictly necessary, the easiest way is to install an application on your computer. [FileZilla](https://filezilla-project.org/) is free and open-source.