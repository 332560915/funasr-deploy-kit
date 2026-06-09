#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/load-offline.sh [PACKAGE_DIR] [INSTALL_ROOT]

Defaults:
  PACKAGE_DIR=../offline-data relative to the project root
  INSTALL_ROOT=/data
  APP_DIR=$INSTALL_ROOT/funasr

Examples:
  bash scripts/load-offline.sh
  bash scripts/load-offline.sh ../offline-data /opt
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

PACKAGE_DIR="${1:-${REPO_ROOT}/../offline-data}"
INSTALL_ROOT="${2:-/data}"

case "${PACKAGE_DIR}" in
  /*) ;;
  *) PACKAGE_DIR="$(cd -- "${PACKAGE_DIR}" && pwd)" ;;
esac

case "${INSTALL_ROOT}" in
  /*) ;;
  *) INSTALL_ROOT="$(cd -- "${INSTALL_ROOT}" && pwd)" ;;
esac

APP_DIR="${INSTALL_ROOT%/}/funasr"
IMAGES_TAR="${PACKAGE_DIR}/funasr-images.tar"
RUNTIME_TGZ="${PACKAGE_DIR}/funasr-runtime-data.tgz"
CHECKSUM_FILE="${PACKAGE_DIR}/SHA256SUMS.txt"

if [ ! -f "${IMAGES_TAR}" ]; then
  echo "Missing ${IMAGES_TAR}" >&2
  exit 1
fi

if [ ! -f "${RUNTIME_TGZ}" ]; then
  echo "Missing ${RUNTIME_TGZ}" >&2
  exit 1
fi

if [ -f "${CHECKSUM_FILE}" ] && command -v sha256sum >/dev/null 2>&1; then
  (
    cd "${PACKAGE_DIR}"
    sha256sum -c SHA256SUMS.txt
  )
fi

docker load -i "${IMAGES_TAR}"

if [ -d "${APP_DIR}" ]; then
  BACKUP_DIR="${APP_DIR}.bak-$(date +%Y%m%d%H%M%S)"
  echo "Existing ${APP_DIR} found, move it to ${BACKUP_DIR}"
  if [ -f "${APP_DIR}/docker-compose.offline.yml" ]; then
    (
      cd "${APP_DIR}"
      docker compose -f docker-compose.offline.yml down || true
    )
  fi
  mv "${APP_DIR}" "${BACKUP_DIR}"
fi

mkdir -p "${APP_DIR}"
tar -xzf "${RUNTIME_TGZ}" -C "${APP_DIR}"

mkdir -p "${APP_DIR}/logs/funasr-server" "${APP_DIR}/logs/http-api" "${APP_DIR}/tmp/http-api"
chmod +x "${APP_DIR}/config/start-funasr.sh"

cd "${APP_DIR}"
docker compose -f docker-compose.offline.yml up -d

echo "FunASR Deploy Kit installed to ${APP_DIR}"
