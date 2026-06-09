#!/usr/bin/env bash

# Docker 镜像相关函数。
# 镜像名统一来自 deploy-template/compose.env.template，避免构建、启动和离线打包不一致。

load_compose_defaults() {
  require_file "${COMPOSE_ENV_TEMPLATE}"
  # compose.env.template 是镜像名和 Compose 变量的唯一模板来源。
  # 构建、启动、离线打包都读取它，避免不同场景使用不同镜像名。
  set -a
  # shellcheck disable=SC1090
  . "${COMPOSE_ENV_TEMPLATE}"
  set +a
}

build_component_image() {
  local target="$1"
  load_compose_defaults
  require_docker_available

  # 每个组件只知道自己的 Dockerfile 和构建上下文。
  # 镜像名统一来自 compose.env.template。
  case "${target}" in
    funasr-server)
      docker build \
        -t "${FUNASR_SERVER_IMAGE}" \
        -f "${REPO_ROOT}/components/funasr-server/Dockerfile" \
        "${REPO_ROOT}/components/funasr-server"
      ;;
    http-api)
      docker build \
        -t "${HTTP_API_IMAGE}" \
        -f "${REPO_ROOT}/components/http-api/Dockerfile" \
        "${REPO_ROOT}/components/http-api"
      ;;
    *)
      usage_error "未知组件：${target}"
      ;;
  esac
}

build_all_images() {
  build_component_image funasr-server
  build_component_image http-api
}

require_image() {
  local image="$1"

  require_docker_available

  # docker image inspect 不会触发拉取，只检查本机 Docker 是否已经存在该镜像。
  if ! docker image inspect "${image}" >/dev/null 2>&1; then
    echo "错误：缺少 Docker 镜像：${image}" >&2
    echo "提示：请先构建镜像，或去掉 --no-build 后重新执行。" >&2
    exit 1
  fi
}

require_runtime_images() {
  load_compose_defaults
  require_image "${FUNASR_SERVER_IMAGE}"
  require_image "${HTTP_API_IMAGE}"
}
