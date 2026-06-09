#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
# shellcheck source=lib/common.sh
. "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'USAGE'
用法:
  bash scripts/quick-start.sh [INSTALL_BASE] [--yes] [--no-build]

默认值:
  INSTALL_BASE=/data/funasr

示例:
  bash scripts/quick-start.sh
  bash scripts/quick-start.sh /opt/funasr
  bash scripts/quick-start.sh /opt/funasr --yes

说明：
  快速开始会按默认配置构建镜像、生成运行目录、启动服务并输出验证命令。
USAGE
}

INSTALL_BASE="${DEFAULT_INSTALL_BASE}"
ASSUME_YES="${YES:-0}"
BUILD_IMAGES=1

# 参数尽量少：快速开始只允许改安装目录、跳过构建或自动确认。
# 更细的部署控制交给 deploy-online.sh。
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
    *)
      INSTALL_BASE="${arg}"
      ;;
  esac
done

INSTALL_BASE="$(resolve_path_allow_missing "${INSTALL_BASE}")"

cat <<INFO
FunASR Deploy Kit 快速开始

工程目录：
  ${REPO_ROOT}

运行目录：
  ${INSTALL_BASE}

将执行：
  1. 构建镜像（可用 --no-build 跳过）
  2. 初始化运行目录
  3. 启动 FunASR Server 和 HTTP API
INFO

confirm_or_exit "是否继续快速启动到 ${INSTALL_BASE} ?" "${ASSUME_YES}"

if [ "${BUILD_IMAGES}" = "1" ]; then
  build_all_images
else
  # --no-build 只适用于本机已经存在运行镜像的情况。
  require_runtime_images
fi

# quick-start 的职责是第一次跑通。真正的运行目录生成和服务启动复用在线部署脚本，
# 这样快速体验和正式部署不会走出两套不同逻辑。
bash "${SCRIPT_DIR}/deploy-online.sh" "${INSTALL_BASE}" --yes --no-build

cat <<INFO

完成：FunASR Deploy Kit 已启动。

验证命令：
  cd ${INSTALL_BASE}
  docker compose ps
  curl http://127.0.0.1:18000/health

Swagger：
  http://127.0.0.1:18000/docs

识别测试：
  curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
INFO
