# ☁️ Group 5: Automated Static Website Cloud Deployment

## 📋 Project Overview
This repository contains the automated deployment architecture for Group 5's Cloud Infrastructure project. The entire infrastructure is provisioned securely on Microsoft Azure using Infrastructure as Code (IaC) via an automated Azure CLI bash script.

## 🏗️ Architecture & Configurations
Our architecture adheres to cloud security best practices by utilizing an isolated Virtual Network and strict Network Security Group (NSG) rules.
* **Resource Group:** `Group5-Web-RG-v6` (Location: Denmark East)
* **Networking:** Virtual Network (`Group5VNet`) with a dedicated `WebSubnet` (10.0.1.0/24).
* **Security (NSG):** Inbound rules specifically configured to allow standard web traffic (Port 80 HTTP, Port 443 HTTPS) and secure administration (Port 22 SSH).
* **Compute:** Ubuntu 22.04 LTS Linux Virtual Machine (`Group5WebServer`, Size: Standard_B1s).
* **Web Server:** NGINX, automatically installed, configured, and populated with static HTML upon boot via a `cloud-init` custom data injection.

## 🚀 Deployment Steps (Zero Manual Portal Clicks)
To completely recreate this environment from scratch without using the Azure Portal UI:
1. Open the Azure Cloud Shell (Bash environment).
2. Upload the `deploy.sh` script provided in this repository.
3. Make the script executable by running: `chmod +x deploy.sh`
4. Execute the automation pipeline: `./deploy.sh`
5. The script will automatically provision the network, deploy the VM, install NGINX, write the custom HTML files, and output the final Public IP address for browser access.