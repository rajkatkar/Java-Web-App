#!/bin/bash

# Update packages
apt update -y

# Install Java and wget
apt install -y openjdk-8-jdk wget

# Move to /opt directory
cd /opt

# Download Nexus
wget https://download.sonatype.com/nexus/3/nexus-3.47.1-01-unix.tar.gz

# Extract Nexus
tar -xvf nexus-3.47.1-01-unix.tar.gz

# Remove tar file
rm -rf nexus-3.47.1-01-unix.tar.gz

# Rename folder
mv nexus-3.* nexus3

# Create nexus user
useradd -m -s /bin/bash nexus

# Create sonatype-work directory
mkdir -p /opt/sonatype-work

# Give permissions
chown -R nexus:nexus /opt/nexus3
chown -R nexus:nexus /opt/sonatype-work

# Configure nexus to run as nexus user
echo 'run_as_user="nexus"' > /opt/nexus3/bin/nexus.rc

# Create systemd service for Nexus
cat <<EOF > /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
User=nexus
LimitNOFILE=65536
ExecStart=/opt/nexus3/bin/nexus start
ExecStop=/opt/nexus3/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Enable Nexus service
systemctl enable nexus

# Start Nexus
systemctl start nexus
