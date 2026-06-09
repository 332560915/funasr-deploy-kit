#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
# shellcheck source=lib/common.sh
. "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'USAGE'
用法:
  bash scripts/install-offline.sh [OFFLINE_DATA_DIR] [INSTALL_BASE] [SOURCE_PROJECT_DIR] [--yes]

默认值:
  OFFLINE_DATA_DIR=../offline-data，相对于工程根目录
  INSTALL_BASE=/data/funasr
  SOURCE_PROJECT_DIR=当前工程根目录

示例:
  bash scripts/install-offline.sh
  bash scripts/install-offline.sh ../offline-data /opt/funasr
  bash scripts/install-offline.sh ../offline-data /opt/funasr . --yes

说明：
  离线安装只加载离线数据，不重新构建镜像。离线包外层 install.sh 会调用本脚本。
USAGE
}

OFFLINE_DATA_DIR="${REPO_ROOT}/../offline-data"
INSTALL_BASE="${DEFAULT_INSTALL_BASE}"
SOURCE_PROJECT_DIR="${REPO_ROOT}"
ASSUME_YES="${YES:-0}"
POSITION_INDEX=0

# install-offline.sh 是底层离线安装入口，参数分别是：
# 1. offline-data 目录
# 2. 最终安装目录，例如 /data/funasr
# 3. 工程来源目录
# 普通用户通常不直接调用它，而是使用离线包外层 install.sh。
for arg in "$@"; do
  case "${arg}" in
    -h|--help)
      usage
      exit 0
      ;;
    -y|--yes)
      ASSUME_YES=1
      ;;
    *)
      POSITION_INDEX=$((POSITION_INDEX + 1))
      case "${POSITION_INDEX}" in
        1) OFFLINE_DATA_DIR="${arg}" ;;
        2) INSTALL_BASE="${arg}" ;;
        3) SOURCE_PROJECT_DIR="${arg}" ;;
        *) usage_error "Too many arguments: ${arg}" ;;
      esac
      ;;
  esac
done

OFFLINE_DATA_DIR="$(resolve_path_allow_missing "${OFFLINE_DATA_DIR}")"
INSTALL_BASE="$(resolve_path_allow_missing "${INSTALL_BASE}")"
SOURCE_PROJECT_DIR="$(resolve_path_allow_missing "${SOURCE_PROJECT_DIR}")"

PROJECT_DIR="${INSTALL_BASE}/${PROJECT_NAME}"
RUNTIME_DIR="${INSTALL_BASE}/runtime"
IMAGES_TAR="${OFFLINE_DATA_DIR}/funasr-images.tar"
RUNTIME_TGZ="${OFFLINE_DATA_DIR}/runtime-data.tgz"
CHECKSUM_FILE="${OFFLINE_DATA_DIR}/SHA256SUMS.txt"

require_file "${IMAGES_TAR}"
require_file "${RUNTIME_TGZ}"
require_file "${SOURCE_PROJECT_DIR}/deploy-template/docker-compose.yml"
require_file "${SOURCE_PROJECT_DIR}/deploy-template/compose.env.template"
require_docker_compose_available

cat <<INFO
FunASR Deploy Kit 离线安装

离线数据目录：
  ${OFFLINE_DATA_DIR}

工程来源目录：
  ${SOURCE_PROJECT_DIR}

最终运行目录：
  ${INSTALL_BASE}

运行数据目录：
  ${RUNTIME_DIR}

工程资料目录：
  ${PROJECT_DIR}

说明：
  docker-compose.yml、.env 和 runtime/ 是最小运行集合。
  ${PROJECT_NAME}/ 只是脚本、文档和源码资料，不影响服务运行。
INFO

confirm_or_exit "是否继续离线安装到 ${INSTALL_BASE} ?" "${ASSUME_YES}"

if [ -f "${CHECKSUM_FILE}" ] && command -v sha256sum >/dev/null 2>&1; then
  # 有校验文件且系统支持 sha256sum 时，先校验再导入镜像。
  (
    cd "${OFFLINE_DATA_DIR}"
    sha256sum -c SHA256SUMS.txt
  )
fi

docker load -i "${IMAGES_TAR}"

# 离线安装同样采用“备份旧目录，再生成新目录”，保证安装结果干净。
backup_existing_install "${INSTALL_BASE}"
mkdir -p "${PROJECT_DIR}" "${RUNTIME_DIR}"

# 工程资料和运行数据分开恢复：
# - PROJECT_DIR 保存文档、脚本和源码
# - RUNTIME_DIR 保存模型、配置、日志和临时目录
copy_dir_contents "${SOURCE_PROJECT_DIR}" "${PROJECT_DIR}"
tar -xzf "${RUNTIME_TGZ}" -C "${RUNTIME_DIR}"

mkdir -p "${RUNTIME_DIR}/logs/funasr-server" "${RUNTIME_DIR}/logs/http-api" "${RUNTIME_DIR}/tmp/http-api"

cp "${SOURCE_PROJECT_DIR}/deploy-template/docker-compose.yml" "${INSTALL_BASE}/docker-compose.yml"
cp "${SOURCE_PROJECT_DIR}/deploy-template/compose.env.template" "${INSTALL_BASE}/.env"
cp "${SOURCE_PROJECT_DIR}/deploy-template/README.md" "${INSTALL_BASE}/README.md"
cp "${SOURCE_PROJECT_DIR}/deploy-template/README.en.md" "${INSTALL_BASE}/README.en.md"

require_runtime_ports_available "${INSTALL_BASE}"

# 在安装根目录启动，确保 Compose 能读取同目录 .env 和相对挂载路径。
(
  cd "${INSTALL_BASE}"
  docker compose up -d
)

cat <<INFO
完成：FunASR Deploy Kit 已安装到 ${INSTALL_BASE}
运行编排文件：${INSTALL_BASE}/docker-compose.yml
运行编排配置：${INSTALL_BASE}/.env
运行数据目录：${RUNTIME_DIR}
工程资料目录：${PROJECT_DIR}
提示：热词文件：${RUNTIME_DIR}/config/hotwords.txt
提示：热词格式参考：${RUNTIME_DIR}/config/hotwords.txt.template
INFO
