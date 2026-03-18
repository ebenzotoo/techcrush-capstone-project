
RESOURCE_GROUP="Group5-Web-RG"
LOCATION="eastus" 
VNET_NAME="Group5VNet"
SUBNET_NAME="WebSubnet"
NSG_NAME="WebNSG"

echo "Starting Group 5 Cloud Deployment..."

echo "1. Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "🌐 2. Creating Virtual Network and Subnet..."
az network vnet create --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix 10.0.0.0/16 \
  --subnet-name $SUBNET_NAME \
  --subnet-prefix 10.0.1.0/24

echo " 3. Creating Network Security Group (NSG)..."
az network nsg create --resource-group $RESOURCE_GROUP --name $NSG_NAME

echo " 4. Configuring Inbound Rule for Web Traffic (Port 80 & 443)..."

az network nsg rule create --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME --name Allow-HTTP --protocol tcp \
  --priority 100 --destination-port-range 80 --access allow


az network nsg rule create --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME --name Allow-HTTPS --protocol tcp \
  --priority 110 --destination-port-range 443 --access allow

echo " 5. Configuring Inbound Rule for SSH (Port 22)..."

az network nsg rule create --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME --name Allow-SSH --protocol tcp \
  --priority 120 --destination-port-range 22 --access allow

echo "✅ Phase 1 Complete: Network is ready."



VM_NAME="Group5WebServer"
ADMIN_USER="azureuser"

echo "⚙️ 6. Creating cloud-init script for automated NGINX setup..."
cat <<EOF > cloud-init.txt
#cloud-config
package_upgrade: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - echo "<!DOCTYPE html><html><head><title>Group 5 Unique Website</title><style>body { font-family: 'Segoe UI', sans-serif; text-align: center; margin-top: 50px; background-color: #f9f9f9; color: #333; } h1 { color: #2c3e50; } .container { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); display: inline-block; }</style></head><body><div class='container'><h1>Welcome to Group 5's Cloud Deployment!</h1><p>This server was provisioned 100% via Azure CLI.</p><p>Web Server: <strong>NGINX</strong></p><p>Team: Ghana Communication Technology University</p></div></body></html>" > /var/www/html/index.html
EOF

echo "💻 7. Deploying the Linux Virtual Machine..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image Ubuntu2204 \
  --admin-username $ADMIN_USER \
  --generate-ssh-keys \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --nsg $NSG_NAME \
  --public-ip-sku Standard \
  --custom-data cloud-init.txt

echo "🔍 8. Fetching the Public IP Address..."
PUBLIC_IP=$(az vm show --show-details --resource-group $RESOURCE_GROUP --name $VM_NAME --query publicIps -o tsv)

echo "=========================================="
echo "✅ DEPLOYMENT COMPLETE!"
echo "🌍 Your Group 5 website is live at: http://$PUBLIC_IP"
echo "=========================================="