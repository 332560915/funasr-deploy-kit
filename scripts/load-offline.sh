#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# 底层离线加载脚本保持非交互，方便外层 install.sh 或自动化流程调用。
# 面向人工安装时，优先使用离线包外层的 install.sh，它会展示路径并要求确认。
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

# PACKAGE_DIR 是 funasr-images.tar、funasr-runtime-data.tgz 所在目录。
case "${PACKAGE_DIR}" in
  /*) ;;
  *) PACKAGE_DIR="$(cd -- "${PACKAGE_DIR}" && pwd)" ;;
esac

# INSTALL_ROOT 是安装根目录，最终运行目录固定为 INSTALL_ROOT/funasr。
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
  # 有校验文件时先校验离线数据，避免导入损坏的大文件。
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
    # 替换运行目录前先尝试停止旧服务，失败也继续备份，避免卡住迁移。
    (
      cd "${APP_DIR}"
      docker compose -f docker-compose.offline.yml down || true
    )
  fi
  mv "${APP_DIR}" "${BACKUP_DIR}"
fi

mkdir -p "${APP_DIR}"
tar -xzf "${RUNTIME_TGZ}" -C "${APP_DIR}"

# 运行目录包不保存日志和临时文件，这里在目标机器上重新创建。
mkdir -p "${APP_DIR}/logs/funasr-server" "${APP_DIR}/logs/http-api" "${APP_DIR}/tmp/http-api"
chmod +x "${APP_DIR}/config/start-funasr.sh"

cd "${APP_DIR}"
docker compose -f docker-compose.offline.yml up -d

echo "FunASR Deploy Kit installed to ${APP_DIR}"
