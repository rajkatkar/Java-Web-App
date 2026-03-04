#!/bin/bash

apt update -y

# Create ansible user
useradd -m -s /bin/bash ansibleadmin

# Set password
echo "ansibleadmin:ansibleadmin" | chpasswd

# Give sudo access
echo "ansibleadmin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansibleadmin

# Enable SSH password login
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Fix Ubuntu EC2 cloud-init SSH config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/60-cloudimg-settings.conf

# Restart SSH
systemctl restart ssh

# Install packages
apt install -y software-properties-common

# Install Ansible
add-apt-repository --yes --update ppa:ansible/ansible
apt install -y ansible

# Install pip
apt install -y python3-pip

# Install docker python module
pip3 install docker
