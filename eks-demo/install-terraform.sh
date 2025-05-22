#!/bin/bash


# Install Terraform
echo "[TASK 1] Install Base Packages"

# Check if the OS is Ubuntu
if grep -q "Ubuntu" /etc/os-release; then
    echo "Running on Ubuntu. Executing Ubuntu-specific commands..."
    apt-get update >/dev/null 2>&1
    apt-get install -y  jq wget unzip  >/dev/null 2>&1

elif grep -q "RedHat" /etc/os-release; then
     echo "Running on RedHat. Executing RedHat-specific commands..."
     yum install -y  jq wget unzip  >/dev/null 2>&1

elif grep -q "CentOS" /etc/os-release; then   
     echo "Running on CentOS. Executing CentOS-specific commands..."
     yum install -y  jq wget unzip  >/dev/null 2>&1

else
    echo "This script is intended to run on Ubuntu or CentOS only. Exiting..."
    exit 1
fi     

# Download Terraform
echo "[TASK 2] Install Terraform Packages"
wget https://releases.hashicorp.com/terraform/1.5.2/terraform_1.5.2_linux_amd64.zip -P /root/ >/dev/null 2>&1
unzip /root/terraform_1.5.2_linux_amd64.zip
mv terraform /usr/bin/
chmod +x /usr/bin/terraform
terraform --version

