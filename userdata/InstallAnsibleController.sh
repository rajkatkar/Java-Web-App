#!/bin/bash

# Update packages
apt update -y

# Create ansible user
useradd -m ansibleadmin

# Set password
echo "ansibleadmin:ansibleadmin" | chpasswd

# Add sudo permission
echo "ansibleadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Enable password authentication
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart ssh

# Install required packages
apt install -y software-properties-common

# Install Ansible
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible

# Install Python pip
apt install -y python3-pip

# Install docker python library for Ansible docker module
pip3 install docker