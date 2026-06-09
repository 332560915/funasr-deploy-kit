#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
# shellcheck source=lib/common.sh
. "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'USAGE'
用法:
  bash scripts/package-offline.sh [OUTPUT_DIR] [--no-build]

默认值:
  OUTPUT_DIR=dist

示例:
  bash scripts/package-offline.sh
  bash scripts/package-offline.sh /data/offline-package
  bash scripts/package-offline.sh /data/offline-package --no-build

说明：
  离线打包用于有网络环境。脚本会确认模型目录、保存镜像、打包运行数据，
  并生成一个可直接传输的 funasr-deploy-kit-offline.tar.gz。
USAGE
}

OUTPUT_DIR="${REPO_ROOT}/dist"
BUILD_IMAGES=1

# 离线打包默认会先构建镜像，保证交付包包含最新镜像。
# 如果调用方已经明确构建过，可以通过 --no-build 跳过。
for arg in "$@"; do
  case "${arg}" in
    -h|--help)
      usage
      exit 0
      ;;
    --no-build)
      BUILD_IMAGES=0
      ;;
    --build)
      BUILD_IMAGES=1
      ;;
    *)
      OUTPUT_DIR="${arg}"
      ;;
  esac
done

OUTPUT_DIR="$(resolve_path_allow_missing "${OUTPUT_DIR}")"
PACKAGE_NAME="${PROJECT_NAME}-offline"
PACKAGE_ROOT="${OUTPUT_DIR}/${PACKAGE_NAME}"
PROJECT_DIR="${PACKAGE_ROOT}/${PROJECT_NAME}"
OFFLINE_DATA_DIR="${PACKAGE_ROOT}/offline-data"
ARCHIVE_PATH="${OUTPUT_DIR}/${PACKAGE_NAME}.tar.gz"
MODELS_DIR="${TEMPLATE_DIR}/models"
RUNTIME_STAGING_DIR="${PACKAGE_ROOT}/runtime-staging"
OFFLINE_PACKAGE_TEMPLATE_DIR="${TEMPLATE_DIR}/offline-package"

load_compose_defaults
require_command tar
require_command rsync
require_command sha256sum
require_non_empty_dir "${MODELS_DIR}"
require_file "${HTTP_API_ENV_TEMPLATE}"
require_file "${OFFLINE_PACKAGE_TEMPLATE_DIR}/install.sh"
require_file "${OFFLINE_PACKAGE_TEMPLATE_DIR}/README.md"
require_file "${OFFLINE_PACKAGE_TEMPLATE_DIR}/README.en.md"

# 离线环境不能依赖网络下载模型，所以这里强制要求 deploy-template/models 非空。
if [ "${BUILD_IMAGES}" = "1" ]; then
  build_all_images
else
  # 离线包必须包含镜像；跳过构建时也要确认本机已经有这些镜像。
  require_runtime_images
fi

mkdir -p "${OUTPUT_DIR}"
rm -rf "${PACKAGE_ROOT}" "${ARCHIVE_PATH}"
mkdir -p "${PROJECT_DIR}" "${OFFLINE_DATA_DIR}"

# 如果输出目录位于仓库内部，需要额外排除它，避免把正在生成的离线包递归打进去。
OUTPUT_REL="__funasr_no_extra_exclude__"
case "${OUTPUT_DIR}" in
  "${REPO_ROOT}"/*)
    OUTPUT_REL="${OUTPUT_DIR#${REPO_ROOT}/}"
    ;;
esac

echo "提示：复制工程资料..."
# 工程目录随离线包一起带走，便于离线环境查看文档、脚本和源码。
# 运行数据不混在工程目录里，而是单独进入 offline-data/runtime-data.tgz。
if [ "${OUTPUT_REL}" != "__funasr_no_extra_exclude__" ]; then
  copy_project_reference "${REPO_ROOT}" "${PROJECT_DIR}" "/${OUTPUT_REL}/"
else
  copy_project_reference "${REPO_ROOT}" "${PROJECT_DIR}"
fi

echo "提示：保存 Docker 镜像..."
# 镜像名来自 compose.env.template，和构建、启动使用同一组变量。
docker save -o "${OFFLINE_DATA_DIR}/funasr-images.tar" \
  "${FUNASR_SERVER_IMAGE}" \
  "${HTTP_API_IMAGE}"

echo "提示：打包运行数据..."
# runtime-data.tgz 只保存离线运行必需的数据：配置和模型。
# logs/tmp 在目标机器安装时重新创建。
mkdir -p "${RUNTIME_STAGING_DIR}/config" "${RUNTIME_STAGING_DIR}/models"
copy_dir_contents "${TEMPLATE_DIR}/config" "${RUNTIME_STAGING_DIR}/config"
cp "${HTTP_API_ENV_TEMPLATE}" "${RUNTIME_STAGING_DIR}/config/http-api.env"
touch "${RUNTIME_STAGING_DIR}/config/hotwords.txt"
copy_dir_contents "${MODELS_DIR}" "${RUNTIME_STAGING_DIR}/models"
tar \
  --dereference \
  --exclude='models/.cache/*' \
  -czf "${OFFLINE_DATA_DIR}/runtime-data.tgz" \
  -C "${RUNTIME_STAGING_DIR}" config models

echo "提示：生成校验文件..."
# 校验文件只覆盖离线大文件，安装时会自动校验，提前发现传输损坏。
(
  cd "${OFFLINE_DATA_DIR}"
  sha256sum funasr-images.tar runtime-data.tgz > SHA256SUMS.txt
)

echo "提示：复制离线包入口模板..."
copy_dir_contents "${OFFLINE_PACKAGE_TEMPLATE_DIR}" "${PACKAGE_ROOT}"
chmod +x "${PACKAGE_ROOT}/install.sh"

echo "提示：生成最终压缩包..."
tar -czf "${ARCHIVE_PATH}" -C "${OUTPUT_DIR}" "${PACKAGE_NAME}"

echo "完成：离线包目录：${PACKAGE_ROOT}"
echo "完成：离线包压缩文件：${ARCHIVE_PATH}"
