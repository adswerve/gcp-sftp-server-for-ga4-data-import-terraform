#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y openssh-server

# Assign environment variables to local shell variables
USERNAME_GA4="ga4-importer"
PUBLIC_KEY_GA4=${public_key_ga4}
USERNAME_SFTP=${username_sftp}
PUBLIC_KEY_SFTP=${public_key_sftp}

# Add users without passwords
sudo adduser --comment "" --disabled-password "$USERNAME_GA4"
sudo adduser --comment "" --disabled-password "$USERNAME_SFTP"

# Authorize public keys for the GA4 user
mkdir -p /home/"$USERNAME_GA4"/.ssh
echo "$PUBLIC_KEY_GA4" | sudo tee -a /home/"$USERNAME_GA4"/.ssh/authorized_keys > /dev/null
sudo chown "$USERNAME_GA4":"$USERNAME_GA4" /home/"$USERNAME_GA4"/.ssh
sudo chmod 700 /home/"$USERNAME_GA4"/.ssh
sudo chmod 600 /home/"$USERNAME_GA4"/.ssh/authorized_keys

# Authorize public keys for the SFTP user
mkdir -p /home/"$USERNAME_SFTP"/.ssh
echo "$PUBLIC_KEY_SFTP" | sudo tee -a /home/"$USERNAME_SFTP"/.ssh/authorized_keys > /dev/null
sudo chown "$USERNAME_SFTP":"$USERNAME_SFTP" /home/"$USERNAME_SFTP"/.ssh
sudo chmod 700 /home/"$USERNAME_SFTP"/.ssh
sudo chmod 600 /home/"$USERNAME_SFTP"/.ssh/authorized_keys

# Set up SFTP directories and permissions
sudo mkdir -p /var/sftp/uploads
sudo chown root:root /var/sftp
sudo chmod 755 /var/sftp
sudo chown "$USERNAME_SFTP:$USERNAME_SFTP" /var/sftp/uploads
sudo chmod 755 /var/sftp/uploads

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