#!/usr/bin/env bash

# 基础路径、常量和通用交互函数。
# 本文件不调用 Docker，也不修改文件系统中的业务数据。

SCRIPTS_DIR="$(cd -- "${COMMON_DIR}/.." && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPTS_DIR}/.." && pwd -P)"
PROJECT_NAME="funasr-deploy-kit"
TEMPLATE_DIR="${REPO_ROOT}/deploy-template"
COMPOSE_TEMPLATE="${TEMPLATE_DIR}/docker-compose.yml"
COMPOSE_ENV_TEMPLATE="${TEMPLATE_DIR}/compose.env.template"
HTTP_API_ENV_TEMPLATE="${TEMPLATE_DIR}/config/http-api.env.template"
DEFAULT_INSTALL_BASE="/data/funasr"

usage_error() {
  echo "错误：$1" >&2
  exit 1
}

resolve_path_allow_missing() {
  local input="$1"
  local parent
  local name

  # 允许目标路径尚不存在。相对路径会被解析成绝对路径，
  # 这样后续打印、备份和切换目录时都不会依赖当前工作目录。
  case "${input}" in
    /*)
      printf '%s\n' "${input%/}"
      ;;
    *)
      parent="$(dirname -- "${input}")"
      name="$(basename -- "${input}")"
      mkdir -p "${parent}"
      printf '%s/%s\n' "$(cd -- "${parent}" && pwd -P)" "${name}"
      ;;
  esac
}

confirm_or_exit() {
  local message="$1"
  local assume_yes="${2:-0}"
  local answer

  if [ "${assume_yes}" = "1" ]; then
    return 0
  fi

  printf "%s [y/N]: " "${message}"
  read -r answer
  case "${answer}" in
    y|Y|yes|YES) ;;
    *)
      echo "提示：已取消。"
      exit 1
      ;;
  esac
}
