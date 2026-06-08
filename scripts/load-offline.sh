#!/usr/bin/env bash
set -euo pipefail

PACKAGE_DIR="${1:-/data}"
case "${PACKAGE_DIR}" in
  /*) ;;
  *)
  PACKAGE_DIR="$(cd -- "${PACKAGE_DIR}" && pwd)"
  ;;
esac

docker load -i "${PACKAGE_DIR}/funasr-images.tar"

mkdir -p /data/funasr
tar -xzf "${PACKAGE_DIR}/funasr-runtime-data.tgz" -C /data/funasr

mkdir -p /data/funasr/logs/funasr-server /data/funasr/logs/http-api /data/funasr/tmp/http-api
chmod +x /data/funasr/config/start-funasr.sh

cd /data/funasr
docker compose -f docker-compose.offline.yml up -d
