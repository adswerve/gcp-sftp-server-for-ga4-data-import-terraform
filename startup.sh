#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y openssh-server

# Assign environment variables to local shell variables
USERNAME=${username}
PASSWORD=${password}

# Add user and set password
sudo adduser --comment "" --disabled-password "$USERNAME"
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Set up SFTP directories and permissions
sudo mkdir -p /var/sftp/uploads
sudo chown root:root /var/sftp
sudo chmod 755 /var/sftp
sudo chown "$USERNAME:$USERNAME" /var/sftp/uploads

# Configure SSH server for SFTP
sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOT
Match User $USERNAME
ForceCommand internal-sftp
PasswordAuthentication yes
ChrootDirectory /var/sftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
EOT

# Restart SSH service to apply changes
sudo service ssh restart