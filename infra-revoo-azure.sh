#!/bin/bash
# ============================================================
# Revoo - Infraestrutura Azure (DevOps Tools & Cloud Computing)
# Cria: RG, VNet/subnets, NSGs/regras, 2 VMs (Win App + Linux DB)
# ============================================================
set -e

# ======== CONFIG (edite antes de rodar) ========
RG_NAME="rg-revoo-dev"
LOCATION="eastus2"

VNET_NAME="vnet-revoo"
VNET_ADDRESS="10.0.0.0/16"
SUBNET_APP_NAME="subnet-app"
SUBNET_APP_PREFIX="10.0.1.0/24"
SUBNET_DB_NAME="subnet-db"
SUBNET_DB_PREFIX="10.0.2.0/24"

NSG_APP="nsg-revoo-app"
NSG_DB="nsg-revoo-db"

WINDOWS_VM_NAME="vm-revoo-app"
WINDOWS_ADMIN_USER="admwin"
WINDOWS_ADMIN_PASSWORD="TroqueEstaSenhaApp@123"   # TROQUE

LINUX_VM_NAME="vm-revoo-db"
LINUX_ADMIN_USER="admlnx"
LINUX_ADMIN_PASSWORD="TroqueEstaSenhaDb@123"      # TROQUE

APP_PORT="3000"    # porta da aplicação na VM Windows
DB_PORT="3306"     # porta do banco na VM Linux (MySQL)

MY_PUBLIC_IP="$(curl -s ifconfig.me)"

echo "=== Revoo Infra Azure ==="
echo "RG: $RG_NAME | Região: $LOCATION | Seu IP: $MY_PUBLIC_IP"
echo

# 1) Resource Group
az group create --name "$RG_NAME" --location "$LOCATION"

# 2) VNet + Subnets
az network vnet create   -g "$RG_NAME"   -n "$VNET_NAME"   --address-prefix "$VNET_ADDRESS"   --subnet-name "$SUBNET_APP_NAME"   --subnet-prefix "$SUBNET_APP_PREFIX"

az network vnet subnet create   -g "$RG_NAME"   --vnet-name "$VNET_NAME"   -n "$SUBNET_DB_NAME"   --address-prefixes "$SUBNET_DB_PREFIX"

# 3) NSGs
az network nsg create -g "$RG_NAME" -n "$NSG_APP"
az network nsg create -g "$RG_NAME" -n "$NSG_DB"

# 4) NSG App rules
az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_APP"   -n allow-rdp --priority 100   --access Allow --protocol Tcp --direction Inbound   --source-address-prefixes "$MY_PUBLIC_IP/32"   --destination-port-ranges 3389

az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_APP"   -n allow-http --priority 110   --access Allow --protocol Tcp --direction Inbound   --source-address-prefixes Internet   --destination-port-ranges 80 443

az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_APP"   -n allow-app --priority 120   --access Allow --protocol Tcp --direction Inbound   --source-address-prefixes Internet   --destination-port-ranges "$APP_PORT"

# 5) NSG DB rules
az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_DB"   -n allow-ssh --priority 100   --access Allow --protocol Tcp --direction Inbound   --source-address-prefixes "$MY_PUBLIC_IP/32"   --destination-port-ranges 22

az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_DB"   -n allow-db-from-app --priority 110   --access Allow --protocol Tcp --direction Inbound   --source-address-prefixes "$SUBNET_APP_PREFIX"   --destination-port-ranges "$DB_PORT"

# 6) Windows VM (App)
az vm create   -g "$RG_NAME"   -n "$WINDOWS_VM_NAME"   --image Win2022Datacenter   --size Standard_B2s   --admin-username "$WINDOWS_ADMIN_USER"   --admin-password "$WINDOWS_ADMIN_PASSWORD"   --vnet-name "$VNET_NAME"   --subnet "$SUBNET_APP_NAME"   --nsg "$NSG_APP"

az vm open-port -g "$RG_NAME" -n "$WINDOWS_VM_NAME" --port "$APP_PORT" --priority 1001

# 7) Linux VM (DB)
az vm create   -g "$RG_NAME"   -n "$LINUX_VM_NAME"   --image Ubuntu2204   --size Standard_B2s   --authentication-type password   --admin-username "$LINUX_ADMIN_USER"   --admin-password "$LINUX_ADMIN_PASSWORD"   --vnet-name "$VNET_NAME"   --subnet "$SUBNET_DB_NAME"   --nsg "$NSG_DB"

echo
echo "Infra criada! IPs:"
az vm list-ip-addresses -g "$RG_NAME" -o table
