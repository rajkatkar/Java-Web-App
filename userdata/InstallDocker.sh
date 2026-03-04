#!/bin/bash

# Update packages
apt update -y

# Create ansible user
useradd -m ansibleadmin

# Set password
echo "ansibleadmin:ansibleadmin" | chpasswd

# Give sudo access
echo 'ansibleadmin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Enable password authentication
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Install Docker
apt install -y docker.io

# Start Docker
systemctl start docker

# Enable Docker at boot
systemctl enable docker

# Install pip
apt install -y python3-pip

# Install docker python module for Ansible
pip3 install docker

# Add ansible user to docker group
usermod -aG docker ansibleadmin