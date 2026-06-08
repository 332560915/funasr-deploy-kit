# Build Images

This document describes how to build images in an online environment.

## Build All Images

```bash
bash scripts/build.sh
```

Equivalent command:

```bash
docker compose -f deploy/docker-compose.yml build
```

## Build HTTP API Only

```bash
docker compose -f deploy/docker-compose.yml build http-api
```

## Build FunASR Server Only

```bash
docker compose -f deploy/docker-compose.yml build funasr-server
```

## Build Component Images Directly

HTTP API:

```bash
docker build -t local/http-api:latest components/http-api
```

FunASR Server:

```bash
docker build -t local/funasr-runtime-sdk-cpu:0.4.7-is-final components/funasr-server
```

## Cache Notes

Docker reuses cache by layer. The HTTP API Dockerfile copies `pyproject.toml` and `uv.lock` first to install dependencies, then copies application code. When only Python business code changes, dependencies are usually not reinstalled.

The FunASR Server image patches the C++ websocket server and rebuilds `funasr-wss-server` during image build. As long as the Dockerfile and base image do not change, this build layer can hit cache.
