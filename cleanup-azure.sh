#!/bin/bash
# Remove toda a infra do Revoo (cuidado!)
RG_NAME="rg-revoo-dev"
az group delete -n "$RG_NAME" --yes --no-wait
echo "Delete acionado para $RG_NAME"
