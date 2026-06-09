#!/usr/bin/env bash

# 运行目录和工程资料处理函数。
# 这些函数负责生成 /data/funasr 这类真实运行目录，不负责解释用户场景。

stop_existing_stack() {
  local install_base="$1"
  local compose_file="${install_base}/docker-compose.yml"

  # 替换运行目录前尽量停掉旧服务。失败不阻断后续备份，
  # 避免旧环境异常时无法继续重新安装。
  if [ -f "${compose_file}" ]; then
    require_docker_compose_available
    (
      cd "${install_base}"
      docker compose down || true
    )
  fi
}

backup_existing_install() {
  local install_base="$1"
  local backup_dir

  # 部署和离线安装都采用“备份旧目录，再生成新目录”的方式。
  # 这样不会在旧目录中混入新旧配置，回滚时也能找到原始目录。
  if [ -d "${install_base}" ]; then
    backup_dir="${install_base}.bak-$(date +%Y%m%d%H%M%S)"
    echo "提示：发现已有运行目录 ${install_base}，将备份到 ${backup_dir}"
    stop_existing_stack "${install_base}"
    mv "${install_base}" "${backup_dir}"
  fi
}

prepare_runtime_from_template() {
  local install_base="$1"
  local runtime_dir="${install_base}/runtime"

  # 从 deploy-template 生成真实运行目录。
  # deploy-template 只保存模板；运行时实际修改的配置放在 install_base/runtime。
  require_file "${COMPOSE_TEMPLATE}"
  require_file "${COMPOSE_ENV_TEMPLATE}"
  require_file "${HTTP_API_ENV_TEMPLATE}"

  mkdir -p \
    "${runtime_dir}/config" \
    "${runtime_dir}/models" \
    "${runtime_dir}/logs/funasr-server" \
    "${runtime_dir}/logs/http-api" \
    "${runtime_dir}/tmp/http-api"

  # 配置模板整体复制，便于保留 .template 文件作为运行目录中的参考资料。
  # http-api.env 是 HTTP API 实际读取的配置文件。
  copy_dir_contents "${TEMPLATE_DIR}/config" "${runtime_dir}/config"
  cp "${HTTP_API_ENV_TEMPLATE}" "${runtime_dir}/config/http-api.env"

  # 热词模板可以包含注释，实际热词文件默认置空，避免 FunASR 热词解析器误读注释。
  touch "${runtime_dir}/config/hotwords.txt"

  # 在线部署时 models 可以为空；FunASR Server 会按 .env 中的模型 ID 下载。
  # 如果用户预先准备了模型，则复制到运行目录，首次启动可直接使用。
  if [ -d "${TEMPLATE_DIR}/models" ] && [ -n "$(find -L "${TEMPLATE_DIR}/models" -mindepth 1 -print -quit)" ]; then
    copy_dir_contents "${TEMPLATE_DIR}/models" "${runtime_dir}/models"
  fi

  # Compose 文件和 .env 放在安装根目录，确保项目源码目录删除后服务仍可管理。
  cp "${COMPOSE_TEMPLATE}" "${install_base}/docker-compose.yml"
  cp "${COMPOSE_ENV_TEMPLATE}" "${install_base}/.env"
  cp "${TEMPLATE_DIR}/README.md" "${install_base}/README.md"
  cp "${TEMPLATE_DIR}/README.en.md" "${install_base}/README.en.md"
}

load_runtime_env() {
  local install_base="$1"
  local env_file="${install_base}/.env"

  require_file "${env_file}"
  set -a
  # shellcheck disable=SC1090
  . "${env_file}"
  set +a
}

require_runtime_ports_available() {
  local install_base="$1"
  local funasr_port
  local http_port

  load_runtime_env "${install_base}"
  funasr_port="${FUNASR_HOST_PORT:-10095}"
  http_port="${HTTP_API_PORT:-18000}"

  require_port_available "${funasr_port}" "FunASR Server" "${install_base}/.env" "FUNASR_HOST_PORT"
  require_port_available "${http_port}" "HTTP API" "${install_base}/.env" "HTTP_API_PORT"
}

require_port_available() {
  local port="$1"
  local service_name="$2"
  local env_file="$3"
  local env_key="$4"

  if is_port_listening "${port}"; then
    echo "错误：端口 ${port} 已被占用，${service_name} 无法启动。" >&2
    echo "提示：请修改 ${env_file} 中的 ${env_key}，或停止占用该端口的服务。" >&2
    exit 1
  fi
}

is_port_listening() {
  local port="$1"

  if command -v ss >/dev/null 2>&1; then
    ss -ltn | awk '{print $4}' | grep -Eq "(^|:)${port}$"
    return $?
  fi

  if command -v lsof >/dev/null 2>&1; then
    lsof -iTCP:"${port}" -sTCP:LISTEN >/dev/null 2>&1
    return $?
  fi

  if command -v netstat >/dev/null 2>&1; then
    netstat -ltn | awk '{print $4}' | grep -Eq "(^|:)${port}$"
    return $?
  fi

  echo "提示：未找到 ss、lsof 或 netstat，跳过端口 ${port} 预检查。"
  return 1
}

copy_project_reference() {
  local source_project_dir="$1"
  local target_project_dir="$2"
  local extra_exclude="${3:-}"

  # 离线安装会把工程资料复制到安装目录下，方便目标环境查看文档和脚本。
  # 排除规则优先读取工程根目录 .gitignore，避免在脚本中维护大量硬编码列表。
  mkdir -p "${target_project_dir}"
  copy_project_with_excludes "${source_project_dir}" "${target_project_dir}" "${extra_exclude}"
}

copy_dir_contents() {
  local source_dir="$1"
  local target_dir="$2"

  require_dir "${source_dir}"
  mkdir -p "${target_dir}"
  cp -R "${source_dir}/." "${target_dir}/"
}

copy_project_with_excludes() {
  local source_project_dir="$1"
  local target_project_dir="$2"
  local extra_exclude="${3:-}"

  require_command rsync
  require_dir "${source_project_dir}"
  mkdir -p "${target_project_dir}"

  if [ -f "${source_project_dir}/.gitignore" ]; then
    if [ -n "${extra_exclude}" ]; then
      rsync -a \
        --exclude='.git/' \
        --exclude="${extra_exclude}" \
        --exclude-from="${source_project_dir}/.gitignore" \
        "${source_project_dir}/" "${target_project_dir}/"
    else
      rsync -a \
        --exclude='.git/' \
        --exclude-from="${source_project_dir}/.gitignore" \
        "${source_project_dir}/" "${target_project_dir}/"
    fi
  else
    echo "提示：未找到 ${source_project_dir}/.gitignore，将只排除 .git/。"
    if [ -n "${extra_exclude}" ]; then
      rsync -a \
        --exclude='.git/' \
        --exclude="${extra_exclude}" \
        "${source_project_dir}/" "${target_project_dir}/"
    else
      rsync -a \
        --exclude='.git/' \
        "${source_project_dir}/" "${target_project_dir}/"
    fi
  fi
}
