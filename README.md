# Revoo - Scripts DevOps (Azure)

Este repositório contém os scripts usados na entrega **DevOps Tools & Cloud Computing**.

## 1. Provisionamento Azure (IaaS)

Arquivo: `infra-revoo-azure.sh`

Cria:
- Resource Group `rg-revoo-dev`
- VNet `vnet-revoo` com subnets `subnet-app` e `subnet-db`
- NSGs `nsg-revoo-app` e `nsg-revoo-db` com regras:
  - RDP 3389 (restrito ao seu IP)
  - SSH 22 (restrito ao seu IP)
  - Porta da aplicação (default 3000)
  - Porta do banco (default 3306) limitada à subnet da aplicação
- 2 VMs:
  - Windows: `vm-revoo-app` (Front/App/API)
  - Linux: `vm-revoo-db` (Banco)

### Como executar
No **Azure Cloud Shell (Bash)**:
```bash
chmod +x infra-revoo-azure.sh
./infra-revoo-azure.sh
```

**Importante:** edite as senhas no topo do script antes de rodar.

## 2. Banco de Dados (VM Linux)

Pasta: `db/`

- `Dockerfile.mysql` : imagem customizada do MySQL 8
- `init.sql` : cria DB e tabelas iniciais
- `run-db.sh` : build + run do container com volume persistente

Na VM Linux:
```bash
cd db
chmod +x run-db.sh
./run-db.sh
docker ps
docker logs -f mysql-revoo
```

## 3. Aplicação (VM Windows)

Pasta: `windows/`

- `setup-revoo.ps1` : helper para instalar Git e clonar o Revoo

Depois configure a string de conexão apontando para o IP privado da VM Linux (ex.: `10.0.2.4`) e rode o projeto.

## Cleanup
`cleanup-azure.sh` remove o RG inteiro
