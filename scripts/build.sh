#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

COMPOSE_FILE="${1:-${REPO_ROOT}/deploy/docker-compose.yml}"
case "${COMPOSE_FILE}" in
  /*) ;;
  *) COMPOSE_FILE="${REPO_ROOT}/${COMPOSE_FILE}" ;;
esac

docker compose -f "${COMPOSE_FILE}" build
