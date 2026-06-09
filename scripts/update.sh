#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
# shellcheck source=lib/common.sh
. "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'USAGE'
用法:
  bash scripts/update.sh <scenario> [INSTALL_BASE] [--no-build]

场景:
  config          修改 runtime/config/http-api.env 后重新加载 HTTP API
  hotwords        修改 runtime/config/hotwords.txt 后重启 FunASR Server
  http-api        重建 HTTP API 镜像并重启 http-api
  funasr-server   重建 FunASR Server 镜像并重启 funasr-server
  models          替换 runtime/models 后重启整套服务
  compose         同步 deploy-template/docker-compose.yml 和 .env 后重启服务

默认值:
  INSTALL_BASE=/data/funasr

示例:
  bash scripts/update.sh config
  bash scripts/update.sh http-api /data/funasr
  bash scripts/update.sh funasr-server /opt/funasr --no-build
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ] || [ -z "${1:-}" ]; then
  usage
  exit 0
fi

SCENARIO="$1"
shift
INSTALL_BASE="${DEFAULT_INSTALL_BASE}"
BUILD_IMAGES=1

# update.sh 把常见维护动作收敛成几个场景，避免用户记忆多组 docker compose 命令。
# 默认会在涉及代码变更时重建镜像；已有镜像时可使用 --no-build。
for arg in "$@"; do
  case "${arg}" in
    --no-build)
      BUILD_IMAGES=0
      ;;
    --build)
      BUILD_IMAGES=1
      ;;
    *)
      INSTALL_BASE="${arg}"
      ;;
  esac
done

INSTALL_BASE="$(resolve_path_allow_missing "${INSTALL_BASE}")"
require_file "${INSTALL_BASE}/docker-compose.yml"
require_docker_compose_available

compose_up_service() {
  local service="$1"
  # 只重启指定服务，适合配置或单组件镜像更新。
  (
    cd "${INSTALL_BASE}"
    docker compose up -d "${service}"
  )
}

case "${SCENARIO}" in
  config)
    # HTTP API 配置通过 env_file 和 /app/.env 挂载读取，重新创建 http-api 即可生效。
    require_file "${INSTALL_BASE}/runtime/config/http-api.env"
    compose_up_service http-api
    ;;
  hotwords)
    # 热词由 FunASR Server 启动时读取，修改后重启 funasr-server。
    require_file "${INSTALL_BASE}/runtime/config/hotwords.txt"
    (
      cd "${INSTALL_BASE}"
      docker compose restart funasr-server
    )
    ;;
  http-api)
    # HTTP API 代码变更需要重建 http-api 镜像，然后重新创建服务。
    if [ "${BUILD_IMAGES}" = "1" ]; then
      build_component_image http-api
    else
      load_compose_defaults
      require_image "${HTTP_API_IMAGE}"
    fi
    compose_up_service http-api
    ;;
  funasr-server)
    # FunASR Server 启动脚本、源码补丁或 Dockerfile 变更需要重建服务端镜像。
    if [ "${BUILD_IMAGES}" = "1" ]; then
      build_component_image funasr-server
    else
      load_compose_defaults
      require_image "${FUNASR_SERVER_IMAGE}"
    fi
    compose_up_service funasr-server
    ;;
  models)
    # 模型替换影响 FunASR Server 的运行状态，直接重启整套服务最直观。
    require_non_empty_dir "${INSTALL_BASE}/runtime/models"
    (
      cd "${INSTALL_BASE}"
      docker compose down
    )
    require_runtime_ports_available "${INSTALL_BASE}"
    (
      cd "${INSTALL_BASE}"
      docker compose up -d
    )
    ;;
  compose)
    # 模板变更后同步到运行目录，再让 Compose 按新编排更新容器。
    (
      cd "${INSTALL_BASE}"
      docker compose down
    )
    cp "${COMPOSE_TEMPLATE}" "${INSTALL_BASE}/docker-compose.yml"
    cp "${COMPOSE_ENV_TEMPLATE}" "${INSTALL_BASE}/.env"
    cp "${TEMPLATE_DIR}/README.md" "${INSTALL_BASE}/README.md"
    cp "${TEMPLATE_DIR}/README.en.md" "${INSTALL_BASE}/README.en.md"
    require_runtime_ports_available "${INSTALL_BASE}"
    (
      cd "${INSTALL_BASE}"
      docker compose up -d
    )
    ;;
  *)
    usage_error "未知更新场景：${SCENARIO}"
    ;;
esac

echo "完成：更新场景已执行：${SCENARIO}"
