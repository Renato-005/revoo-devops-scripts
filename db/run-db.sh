#!/bin/bash
# Sobe MySQL do Revoo na VM Linux
set -e
IMG="mysql-revoo"
CONTAINER="mysql-revoo"
VOL="revoo-db-data"
PORT="3306"

docker build -f Dockerfile.mysql -t $IMG .
docker volume create $VOL || true

# Remove container antigo se existir
docker rm -f $CONTAINER 2>/dev/null || true

docker run --name $CONTAINER -d -p $PORT:3306 -v $VOL:/var/lib/mysql $IMG

echo "MySQL rodando. Verifique com:"
echo "  docker ps"
echo "  docker logs -f $CONTAINER"
