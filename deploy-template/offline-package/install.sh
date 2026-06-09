#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
PROJECT_DIR="${SCRIPT_DIR}/funasr-deploy-kit"
OFFLINE_DATA_DIR="${SCRIPT_DIR}/offline-data"
INSTALL_ROOT="/data"
PASS_ARG=""

# 外层 install.sh 面向最终交付用户：参数是安装根目录。
# 例如 bash install.sh /opt 表示最终安装到 /opt/funasr。
for arg in "$@"; do
  case "${arg}" in
    -h|--help)
      PASS_ARG="${arg}"
      ;;
    -y|--yes)
      PASS_ARG="${arg}"
      ;;
    *)
      INSTALL_ROOT="${arg}"
      ;;
  esac
done

case "${INSTALL_ROOT}" in
  /*) ;;
  *) INSTALL_ROOT="$(cd -- "${INSTALL_ROOT}" && pwd -P)" ;;
esac

if [ -n "${PASS_ARG}" ]; then
  exec bash "${PROJECT_DIR}/scripts/install-offline.sh" "${OFFLINE_DATA_DIR}" "${INSTALL_ROOT%/}/funasr" "${PROJECT_DIR}" "${PASS_ARG}"
fi

exec bash "${PROJECT_DIR}/scripts/install-offline.sh" "${OFFLINE_DATA_DIR}" "${INSTALL_ROOT%/}/funasr" "${PROJECT_DIR}"
