#!/usr/bin/env bash
set -euo pipefail

# HTTP API 容器启动脚本。
#
# 这些参数控制 HTTP API 的运行并发和进程生命周期。
# 默认采用单进程异步模型，HTTP 入口并发放宽到 20，真正进入 FunASR 识别的业务并发由 ASR_RECOGNITION_CONCURRENCY 控制。

UVICORN_LOG_LEVEL="$(printf '%s' "${LOG_LEVEL:-INFO}" | tr '[:upper:]' '[:lower:]')"

exec uv run uvicorn main:app \
  --host "${HOST:-0.0.0.0}" \
  --port "${PORT:-8000}" \
  --workers "${HTTP_API_WORKERS:-1}" \
  --limit-concurrency "${HTTP_API_LIMIT_CONCURRENCY:-20}" \
  --limit-max-requests "${HTTP_API_LIMIT_MAX_REQUESTS:-1000}" \
  --backlog "${HTTP_API_BACKLOG:-256}" \
  --timeout-keep-alive "${TIMEOUT_KEEP_ALIVE:-360}" \
  --log-level "${UVICORN_LOG_LEVEL}"
