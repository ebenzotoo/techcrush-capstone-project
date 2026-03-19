

RESOURCE_GROUP="Group5-Web-RG-v6"
LOCATION="denmarkeast" 
VNET_NAME="Group5VNet"
SUBNET_NAME="WebSubnet"
NSG_NAME="WebNSG"

echo "🚀 Starting Group 5 Cloud Deployment in Denmark East..."

echo "📦 1. Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "🌐 2. Creating Virtual Network and Subnet..."
az network vnet create --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix 10.0.0.0/16 \
  --subnet-name $SUBNET_NAME \
  --subnet-prefix 10.0.1.0/24

echo "🔒 3. Creating Network Security Group (NSG)..."
az network nsg create --resource-group $RESOURCE_GROUP --name $NSG_NAME

echo "🔓 4. Configuring Inbound Rules for Web Traffic (Port 80 & 443)..."
az network nsg rule create --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME --name Allow-HTTP-Inbound --protocol tcp \
  --direction Inbound --priority 100 --destination-port-range 80 --access allow

az network nsg rule create --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME --name Allow-HTTPS-Inbound --protocol tcp \
  --direction Inbound --priority 110 --destination-port-range 443 --access allow

echo "🔓 5. Configuring Inbound Rule for SSH (Port 22)..."
az network nsg rule create --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME --name Allow-SSH --protocol tcp \
  --direction Inbound --priority 120 --destination-port-range 22 --access allow

echo "🔓 6. Configuring Outbound Rules for Web Traffic (Port 80 & 443)..."
az network nsg rule create --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME --name Allow-HTTP-Outbound --protocol tcp \
  --direction Outbound --priority 100 --destination-port-range 80 --access allow

az network nsg rule create --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME --name Allow-HTTPS-Outbound --protocol tcp \
  --direction Outbound --priority 110 --destination-port-range 443 --access allow


VM_NAME="Group5WebServer"
ADMIN_USER="azureuser"

echo "⚙️ 7. Creating cloud-init script for automated NGINX setup..."
cat <<EOF > cloud-init.txt
#cloud-config
package_upgrade: true
packages:
  - nginx
  - curl
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - curl -fsSL https://raw.githubusercontent.com/ebenzotoo/techcrush-capstone-project/main/Project%202/index.html -o /var/www/html/index.html
  - systemctl reload nginx
EOF

echo "💻 8. Deploying the Linux Virtual Machine..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username $ADMIN_USER \
  --generate-ssh-keys \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --nsg $NSG_NAME \
  --public-ip-sku Standard \
  --custom-data cloud-init.txt

echo "🔍 9. Fetching the Public IP Address..."
PUBLIC_IP=$(az vm show --show-details --resource-group $RESOURCE_GROUP --name $VM_NAME --query publicIps -o tsv)

echo "=========================================="
echo "✅ DEPLOYMENT COMPLETE!"
echo "🌍 Your Group 5 website is live at: http://$PUBLIC_IP"
echo "=========================================="