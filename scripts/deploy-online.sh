#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
# shellcheck source=lib/common.sh
. "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'USAGE'
用法:
  bash scripts/deploy-online.sh [INSTALL_BASE] [--yes] [--no-build] [--no-start]

默认值:
  INSTALL_BASE=/data/funasr

示例:
  bash scripts/deploy-online.sh
  bash scripts/deploy-online.sh /opt/funasr
  bash scripts/deploy-online.sh /opt/funasr --no-build
  bash scripts/deploy-online.sh /opt/funasr --no-start

说明：
  在线部署会生成独立运行目录。服务启动后只依赖 docker-compose.yml、.env 和 runtime/。
USAGE
}

INSTALL_BASE="${DEFAULT_INSTALL_BASE}"
ASSUME_YES="${YES:-0}"
BUILD_IMAGES=1
START_SERVICE=1

# 在线部署是正式部署入口：可以指定安装目录，也可以跳过构建或只生成运行目录。
# 已有安装目录会先备份，避免新旧运行数据混用。
for arg in "$@"; do
  case "${arg}" in
    -h|--help)
      usage
      exit 0
      ;;
    -y|--yes)
      ASSUME_YES=1
      ;;
    --no-build)
      BUILD_IMAGES=0
      ;;
    --build)
      BUILD_IMAGES=1
      ;;
    --no-start)
      START_SERVICE=0
      ;;
    *)
      INSTALL_BASE="${arg}"
      ;;
  esac
done

INSTALL_BASE="$(resolve_path_allow_missing "${INSTALL_BASE}")"
RUNTIME_DIR="${INSTALL_BASE}/runtime"

cat <<INFO
FunASR Deploy Kit 在线部署

工程目录：
  ${REPO_ROOT}

部署模板目录：
  ${TEMPLATE_DIR}

最终运行目录：
  ${INSTALL_BASE}

运行数据目录：
  ${RUNTIME_DIR}

说明：
  docker-compose.yml、.env 和 runtime/ 是最小运行集合。
  工程目录只作为构建、模板和文档来源，安装完成后服务不依赖工程目录。
INFO

confirm_or_exit "是否继续部署到 ${INSTALL_BASE} ?" "${ASSUME_YES}"

if [ "${BUILD_IMAGES}" = "1" ]; then
  build_all_images
else
  # 跳过构建时提前检查镜像是否存在，避免错误延迟到 docker compose up。
  require_runtime_images
fi

# 运行目录是服务的唯一依赖集合。生成前先备份旧目录，再从模板初始化。
backup_existing_install "${INSTALL_BASE}"
mkdir -p "${INSTALL_BASE}"
prepare_runtime_from_template "${INSTALL_BASE}"

if [ "${START_SERVICE}" = "1" ]; then
  require_docker_compose_available
  require_runtime_ports_available "${INSTALL_BASE}"
  # docker compose 必须在安装根目录执行，因为 .env 和相对挂载路径都在这里。
  (
    cd "${INSTALL_BASE}"
    docker compose up -d
  )
fi

cat <<INFO
完成：FunASR Deploy Kit 已部署到 ${INSTALL_BASE}
运行编排文件：${INSTALL_BASE}/docker-compose.yml
运行编排配置：${INSTALL_BASE}/.env
运行数据目录：${RUNTIME_DIR}
提示：热词文件：${RUNTIME_DIR}/config/hotwords.txt
提示：热词格式参考：${RUNTIME_DIR}/config/hotwords.txt.template
INFO
