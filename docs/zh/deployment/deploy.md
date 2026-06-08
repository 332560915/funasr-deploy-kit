# 启动部署

本文说明在线环境或已经具备镜像的环境中如何启动平台。

## 准备目录

部署目录建议为：

```text
/data/funasr
|-- docker-compose.yml
|-- docker-compose.offline.yml
|-- config/
|-- logs/
|-- models/
`-- tmp/
```

在仓库内本地启动时，直接使用 `deploy/` 目录即可。

## 准备配置和模型

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
```

把 FunASR 模型文件放到：

```text
deploy/models
```

## 启动服务

在线构建并启动：

```bash
docker compose -f deploy/docker-compose.yml up -d --build
```

镜像已存在时启动：

```bash
docker compose -f deploy/docker-compose.yml up -d
```

离线环境启动：

```bash
docker compose -f docker-compose.offline.yml up -d
```

## 查看状态

```bash
docker compose -f deploy/docker-compose.yml ps
```

在 `/data/funasr` 部署目录中：

```bash
docker compose ps
```

## 查看日志

```bash
docker compose -f deploy/docker-compose.yml logs -f http-api
docker compose -f deploy/docker-compose.yml logs -f funasr-server
```

宿主机日志目录：

```text
deploy/logs/http-api
deploy/logs/funasr-server
```

## 停止服务

```bash
docker compose -f deploy/docker-compose.yml down
```
