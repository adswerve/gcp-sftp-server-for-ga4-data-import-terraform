#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y openssh-server
sudo apt install -y google-cloud-sdk

# Assign environment variables to local shell variables
USERNAME_GA4="ga4-importer"
#PUBLIC_KEY_GA4=${public_key_ga4}
USERNAME_SFTP=${username_sftp}
#PUBLIC_KEY_SFTP=${public_key_sftp}
GCS_BUCKET=${gcs_bucket}

# Add users without passwords
sudo adduser --comment "" --disabled-password "$USERNAME_GA4"
sudo adduser --comment "" --disabled-password "$USERNAME_SFTP"

# Authorize public keys for the GA4 user
mkdir -p /home/"$USERNAME_GA4"/.ssh
#echo "$PUBLIC_KEY_GA4" | sudo tee -a /home/"$USERNAME_GA4"/.ssh/authorized_keys > /dev/null
echo "${public_key_ga4}" | sudo tee -a /home/"$USERNAME_GA4"/.ssh/authorized_keys > /dev/null
sudo chown "$USERNAME_GA4":"$USERNAME_GA4" /home/"$USERNAME_GA4"/.ssh
sudo chmod 755 /home/"$USERNAME_SFTP"
sudo chmod 700 /home/"$USERNAME_GA4"/.ssh
sudo chown "$USERNAME_GA4":"$USERNAME_GA4" /home/"$USERNAME_GA4"/.ssh/authorized_keys
sudo chmod 600 /home/"$USERNAME_GA4"/.ssh/authorized_keys

# Authorize public keys for the SFTP user
mkdir -p /home/"$USERNAME_SFTP"/.ssh
#echo "$PUBLIC_KEY_SFTP" | sudo tee -a /home/"$USERNAME_SFTP"/.ssh/authorized_keys > /dev/null
echo "${public_key_sftp}" | sudo tee -a /home/"$USERNAME_SFTP"/.ssh/authorized_keys > /dev/null
sudo chown "$USERNAME_SFTP":"$USERNAME_SFTP" /home/"$USERNAME_SFTP"/.ssh
sudo chmod 755 /home/"$USERNAME_SFTP"
sudo chmod 700 /home/"$USERNAME_SFTP"/.ssh
sudo chown "$USERNAME_SFTP":"$USERNAME_SFTP" /home/"$USERNAME_SFTP"/.ssh/authorized_keys
sudo chmod 600 /home/"$USERNAME_SFTP"/.ssh/authorized_keys

# Set up SFTP directories and permissions
sudo mkdir -p /var/sftp/uploads
sudo chown "$USERNAME_SFTP:$USERNAME_SFTP" /var/sftp/uploads
sudo chmod 775 /var/sftp/uploads

# Install gcsfuse to mount the Google Cloud Storage (GCS) bucket
#export GCSFUSE_REPO=gcsfuse-$(lsb_release -c -s)
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
#echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update -y
#sudo apt install -y fuse gcsfuse
sudo apt-get install -y fuse gcsfuse

# Mount the GCS bucket directly to the uploads folder
sudo gcsfuse -o allow_other -file-mode=777 -dir-mode=777 "$GCS_BUCKET" /var/sftp/uploads

# Ensure PubkeyAuthentication and AuthorizedKeysFile are set in sshd_config
sudo sed -i '/^#*PubkeyAuthentication/c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sudo sed -i '/^#*AuthorizedKeysFile/c\AuthorizedKeysFile .ssh/authorized_keys' /etc/ssh/sshd_config

# Configure SSH server for SFTP
sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOT
Match User $USERNAME_GA4
ForceCommand internal-sftp
PasswordAuthentication no
ChrootDirectory /var/sftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no

Match User $USERNAME_SFTP
ForceCommand internal-sftp
PasswordAuthentication no
ChrootDirectory /var/sftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
EOT


# Restart SSH service to apply changes
sudo service ssh restart