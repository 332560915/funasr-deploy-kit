#!/usr/bin/env bash

# 通用前置条件检查。
# 这里放“是否存在、是否可用”这类判断，不放具体场景流程。

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "错误：缺少命令：$1" >&2
    exit 1
  fi
}

require_file() {
  if [ ! -f "$1" ]; then
    echo "错误：缺少文件：$1" >&2
    exit 1
  fi
}

require_dir() {
  if [ ! -d "$1" ]; then
    echo "错误：缺少目录：$1" >&2
    exit 1
  fi
}

require_non_empty_dir() {
  require_dir "$1"
  if [ -z "$(find -L "$1" -mindepth 1 -print -quit)" ]; then
    echo "错误：目录为空：$1" >&2
    exit 1
  fi
}

require_docker_available() {
  require_command docker
  if ! docker info >/dev/null 2>&1; then
    echo "错误：Docker 不可用，请启动 Docker 或检查当前用户权限。" >&2
    exit 1
  fi
}

require_docker_compose_available() {
  require_docker_available
  if ! docker compose version >/dev/null 2>&1; then
    echo "错误：Docker Compose v2 不可用，请安装 docker compose 插件。" >&2
    exit 1
  fi
}
