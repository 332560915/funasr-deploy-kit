#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# 输出目录只用于生成离线包，不代表最终安装目录。
# 最终安装目录由离线包外层 install.sh 或 scripts/load-offline.sh 决定。
OUTPUT_DIR="${1:-${REPO_ROOT}/dist}"
case "${OUTPUT_DIR}" in
  /*) ;;
  *) OUTPUT_DIR="${REPO_ROOT}/${OUTPUT_DIR}" ;;
esac

PROJECT_NAME="funasr-deploy-kit"
PACKAGE_NAME="${PROJECT_NAME}-offline"
PACKAGE_ROOT="${OUTPUT_DIR}/${PACKAGE_NAME}"
PROJECT_DIR="${PACKAGE_ROOT}/${PROJECT_NAME}"
OFFLINE_DATA_DIR="${PACKAGE_ROOT}/offline-data"
ARCHIVE_PATH="${OUTPUT_DIR}/${PACKAGE_NAME}.tar.gz"

# 离线运行必须带实际配置文件，不能只带 .example。
ENV_FILE="${REPO_ROOT}/deploy/config/http-api.env"
if [ ! -f "${ENV_FILE}" ]; then
  echo "Missing deploy/config/http-api.env" >&2
  echo "Copy deploy/config/http-api.env.example to deploy/config/http-api.env and confirm values before packaging." >&2
  exit 1
fi

MODELS_DIR="${REPO_ROOT}/deploy/models"
if [ ! -d "${MODELS_DIR}" ] || [ -z "$(find -L "${MODELS_DIR}" -mindepth 1 -print -quit)" ]; then
  echo "Missing deploy/models or it is empty" >&2
  echo "Copy FunASR model files into deploy/models before packaging an offline bundle." >&2
  exit 1
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

echo "Copy project files..."
# 工程目录用于保留脚本、文档和源码；模型、日志、临时文件进入 offline-data 或运行时重新生成。
tar \
  --exclude='./.git' \
  --exclude='./.idea' \
  --exclude='./.venv' \
  --exclude='./components/http-api/.venv' \
  --exclude='./deploy/models' \
  --exclude='./deploy/logs' \
  --exclude='./deploy/tmp' \
  --exclude='./dist' \
  --exclude='./dest' \
  --exclude='./*.tar' \
  --exclude='./*.tgz' \
  --exclude='./*.tar.gz' \
  --exclude='./__pycache__' \
  --exclude='*/__pycache__' \
  --exclude='*.pyc' \
  --exclude='./.pytest_cache' \
  --exclude="./${OUTPUT_REL}" \
  -cf - \
  -C "${REPO_ROOT}" . | tar -xf - -C "${PROJECT_DIR}"

echo "Save Docker images..."
# 离线环境只做 docker load，不在目标机器重新构建镜像。
docker save -o "${OFFLINE_DATA_DIR}/funasr-images.tar" \
  local/funasr-runtime-sdk-cpu:0.4.7-is-final \
  local/http-api:latest

echo "Package runtime data..."
# 运行目录包包含 compose、配置、热词和模型；排除历史日志、临时文件和模型下载缓存。
tar \
  --dereference \
  --exclude='./logs/*' \
  --exclude='./tmp/*' \
  --exclude='./models/.cache/*' \
  -czf "${OFFLINE_DATA_DIR}/funasr-runtime-data.tgz" \
  -C "${REPO_ROOT}/deploy" .

echo "Generate checksums..."
# 校验文件只覆盖 offline-data 中的大文件，安装时 load-offline.sh 会自动校验。
(
  cd "${OFFLINE_DATA_DIR}"
  sha256sum funasr-images.tar funasr-runtime-data.tgz > SHA256SUMS.txt
)

cat > "${PACKAGE_ROOT}/install.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
PROJECT_DIR="${SCRIPT_DIR}/funasr-deploy-kit"
OFFLINE_DATA_DIR="${SCRIPT_DIR}/offline-data"

# 外层安装脚本面向最终使用者：先展示路径，再确认是否继续安装。
usage() {
  cat <<'USAGE'
FunASR Deploy Kit 离线安装

Usage:
  bash install.sh [INSTALL_ROOT] [--yes]

Examples:
  bash install.sh
  bash install.sh /opt
  bash install.sh /opt --yes

Defaults:
  INSTALL_ROOT=/data
  APP_DIR=$INSTALL_ROOT/funasr

说明：
  如需修改安装路径，请把目标根目录作为第一个参数。
  例如 bash install.sh /opt 会安装到 /opt/funasr。
USAGE
}

INSTALL_ROOT="/data"
ASSUME_YES="${YES:-0}"

# 第一个普通参数是安装根目录；--yes/-y 或 YES=1 用于自动化安装。
for arg in "$@"; do
  case "$arg" in
    -h|--help)
      usage
      exit 0
      ;;
    -y|--yes)
      ASSUME_YES=1
      ;;
    *)
      INSTALL_ROOT="$arg"
      ;;
  esac
done

case "${INSTALL_ROOT}" in
  /*) ;;
  *) INSTALL_ROOT="$(cd -- "${INSTALL_ROOT}" && pwd)" ;;
esac

APP_DIR="${INSTALL_ROOT%/}/funasr"

cat <<INFO
FunASR Deploy Kit 离线安装

离线数据目录：
  ${OFFLINE_DATA_DIR}

工程目录：
  ${PROJECT_DIR}

安装根目录：
  ${INSTALL_ROOT}

最终部署目录：
  ${APP_DIR}

如需修改安装路径，请使用：
  bash install.sh /opt
最终将安装到：
  /opt/funasr

INFO

if [ "${ASSUME_YES}" != "1" ]; then
  printf "是否继续安装到 %s ? [y/N]: " "${APP_DIR}"
  read -r answer
  case "${answer}" in
    y|Y|yes|YES) ;;
    *)
      echo "Installation cancelled."
      exit 1
      ;;
  esac
fi

# 实际导入镜像、解压运行目录、启动 Compose 的逻辑由工程内脚本负责。
exec bash "${PROJECT_DIR}/scripts/load-offline.sh" "${OFFLINE_DATA_DIR}" "${INSTALL_ROOT}"
EOF

chmod +x "${PACKAGE_ROOT}/install.sh"

cat > "${PACKAGE_ROOT}/README.md" <<'EOF'
# FunASR Deploy Kit 离线包

这是 `funasr-deploy-kit` 的离线交付包。解压后无需访问源码仓库即可完成校验、安装、启动和验证。

## 目录结构

```text
funasr-deploy-kit-offline/
|-- README.md
|-- README.en.md
|-- install.sh
|-- offline-data/
|   |-- funasr-images.tar
|   |-- funasr-runtime-data.tgz
|   `-- SHA256SUMS.txt
`-- funasr-deploy-kit/
    |-- docs/
    |-- scripts/
    |-- deploy/
    `-- components/
```

## 安装

默认安装到 `/data/funasr`：

```bash
bash install.sh
```

安装到 `/opt/funasr`：

```bash
bash install.sh /opt
```

自动确认安装：

```bash
bash install.sh /opt --yes
```

## 验证

```bash
cd /data/funasr
docker compose -f docker-compose.offline.yml ps
curl http://127.0.0.1:18000/health
```

更多说明见：

```text
funasr-deploy-kit/docs/zh/deployment/offline-deploy.md
```
EOF

cat > "${PACKAGE_ROOT}/README.en.md" <<'EOF'
# FunASR Deploy Kit Offline Package

This is the offline delivery package for `funasr-deploy-kit`. After extraction, you can verify, install, start, and test the service without accessing the source repository.

## Layout

```text
funasr-deploy-kit-offline/
|-- README.md
|-- README.en.md
|-- install.sh
|-- offline-data/
|   |-- funasr-images.tar
|   |-- funasr-runtime-data.tgz
|   `-- SHA256SUMS.txt
`-- funasr-deploy-kit/
    |-- docs/
    |-- scripts/
    |-- deploy/
    `-- components/
```

## Install

Install to `/data/funasr` by default:

```bash
bash install.sh
```

Install to `/opt/funasr`:

```bash
bash install.sh /opt
```

Skip confirmation:

```bash
bash install.sh /opt --yes
```

## Verify

```bash
cd /data/funasr
docker compose -f docker-compose.offline.yml ps
curl http://127.0.0.1:18000/health
```

For more details, see:

```text
funasr-deploy-kit/docs/en/deployment/offline-deploy.md
```
EOF

echo "Create final archive..."
tar -czf "${ARCHIVE_PATH}" -C "${OUTPUT_DIR}" "${PACKAGE_NAME}"

echo "Offline package directory: ${PACKAGE_ROOT}"
echo "Offline package archive:   ${ARCHIVE_PATH}"
