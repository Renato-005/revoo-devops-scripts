#!/bin/bash
set -e

RG_NAME="rg-revoo-dev"

echo "Deletando Resource Group $RG_NAME..."
az group delete -n "$RG_NAME" --yes --no-wait
echo "Delete acionado."
