#!/bin/bash

# Update packages
apt update -y

# Create ansible user
useradd -m -s /bin/bash ansibleadmin

# Set password
echo "ansibleadmin:ansibleadmin" | chpasswd

# Give sudo access
echo "ansibleadmin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansibleadmin

# Enable password authentication
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Fix Ubuntu EC2 cloud-init SSH config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/60-cloudimg-settings.conf

# Restart SSH
systemctl restart ssh

# Install Docker
apt install -y docker.io

# Start Docker
systemctl start docker

# Enable Docker on boot
systemctl enable docker

# Install pip
apt install -y python3-pip

# Install docker python module for Ansible
pip3 install docker

# Add ansible user to docker group
usermod -aG docker ansibleadmin
