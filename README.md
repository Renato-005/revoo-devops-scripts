# Revoo – Scripts de Infraestrutura (Azure + MySQL)

Conjunto de scripts usados para criar o ambiente do projeto **Revoo** na Azure.

## 1. Infraestrutura Azure

**Arquivo:** `infra-revoo-azure.sh`

Cria:

- Resource Group `rg-revoo-dev` em `eastus2`
- VNet `vnet-revoo` (`10.0.0.0/16`)
  - `subnet-app` (`10.0.1.0/24`) – VM Windows (aplicação)
  - `subnet-db` (`10.0.2.0/24`) – VM Linux (banco)
- NSGs `nsg-revoo-app` e `nsg-revoo-db` com regras para:
  - RDP (3389)
  - HTTP/HTTPS (80/443)
  - porta da aplicação (3000)
  - SSH (22)
  - porta do banco (3306) liberada apenas para a subnet da aplicação
- VMs:
  - `vm-revoo-app` – Windows Server 2022
  - `vm-revoo-db` – Ubuntu 22.04

Uso (Azure Cloud Shell):

```bash
chmod +x infra-revoo-azure.sh
./infra-revoo-azure.sh
