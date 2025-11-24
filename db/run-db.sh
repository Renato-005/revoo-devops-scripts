#!/bin/bash
set -e

IMG="mysql-revoo"
CONTAINER="mysql-revoo"
VOL="revoo-db-data"
PORT="3306"

docker build -f Dockerfile.mysql -t "$IMG" .

docker volume create "$VOL" >/dev/null 2>&1 || true
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true

docker run --name "$CONTAINER" -d \
  -p "$PORT":3306 \
  -v "$VOL":/var/lib/mysql \
  "$IMG"

echo "MySQL rodando em db_revoo (user_revoo / senha_revoo) na porta $PORT."
echo "Use: docker ps  e  docker logs -f $CONTAINER"
