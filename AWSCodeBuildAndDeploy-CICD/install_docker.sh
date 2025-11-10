#!/bin/bash
# CodeDeploy script to install Docker and AWS CLI on an EC2 instance (e.g., Amazon Linux 2)

echo "--- Running BeforeInstall Hook: Installing prerequisites ---"

# Install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
echo "Docker installed and service started."

# Install AWS CLI (usually pre-installed, but ensuring compatibility)
sudo yum install -y aws-cli

# Create necessary directory for application files
mkdir -p /home/ec2-user/ci-cd-demo/

echo "Prerequisites installation complete."