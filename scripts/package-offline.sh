#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

OUTPUT_DIR="${1:-${REPO_ROOT}/dist}"
case "${OUTPUT_DIR}" in
  /*) ;;
  *) OUTPUT_DIR="${REPO_ROOT}/${OUTPUT_DIR}" ;;
esac

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

docker save -o "${OUTPUT_DIR}/funasr-images.tar" \
  local/funasr-runtime-sdk-cpu:0.4.7-is-final \
  local/http-api:latest

tar \
  --dereference \
  --exclude='./logs/*' \
  --exclude='./tmp/*' \
  --exclude='./models/.cache/*' \
  -czf "${OUTPUT_DIR}/funasr-runtime-data.tgz" \
  -C "${REPO_ROOT}/deploy" .
