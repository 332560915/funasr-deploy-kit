# 构建镜像

本文说明在线环境中的镜像构建方式。

## 构建全部镜像

```bash
bash scripts/build.sh
```

等价于：

```bash
docker compose -f deploy/docker-compose.yml build
```

## 只构建 HTTP API

```bash
docker compose -f deploy/docker-compose.yml build http-api
```

## 只构建 FunASR Server

```bash
docker compose -f deploy/docker-compose.yml build funasr-server
```

## 直接构建组件镜像

HTTP API：

```bash
docker build -t local/http-api:latest components/http-api
```

FunASR Server：

```bash
docker build -t local/funasr-runtime-sdk-cpu:0.4.7-is-final components/funasr-server
```

## 缓存说明

Docker 会按层复用缓存。HTTP API 的 Dockerfile 先复制 `pyproject.toml` 和 `uv.lock` 安装依赖，再复制业务代码，因此只修改 Python 业务代码时通常不会重新安装依赖。

FunASR Server 镜像会在构建时 patch C++ websocket server 并重新编译 `funasr-wss-server`。只要 Dockerfile 和基础镜像不变，该编译层可以命中缓存。
