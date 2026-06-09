# 在线部署

本文面向正式在线部署场景，对应脚本：

```text
scripts/deploy-online.sh
```

## 适用场景

- 目标机器可以联网构建镜像，或本机已经具备所需镜像。
- 需要生成独立运行目录，例如 `/data/funasr`。
- 需要后续通过运行目录中的 `docker-compose.yml` 管理服务。

## 执行部署

默认会构建镜像、生成运行目录并启动服务：

```bash
bash scripts/deploy-online.sh /data/funasr
```

如果镜像已经存在，可以跳过构建：

```bash
bash scripts/deploy-online.sh /data/funasr --no-build
```

`--no-build` 会检查本机 Docker 是否已有配置中声明的镜像。缺少镜像时会提前报错。

如果只想生成运行目录，不立即启动服务：

```bash
bash scripts/deploy-online.sh /data/funasr --no-start
```

自动确认安装：

```bash
bash scripts/deploy-online.sh /data/funasr --yes
```

## 已有目录处理

如果目标目录已存在，脚本会先尝试停止旧服务，再备份旧目录：

```text
/data/funasr.bak-YYYYMMDDHHMMSS
```

这样可以避免新旧配置混在同一个运行目录里。

## 端口检查

脚本会在旧服务停止之后、启动新服务之前检查端口：

```text
FUNASR_HOST_PORT
HTTP_API_PORT
```

默认端口：

```text
10095
18000
```

如果端口被其他服务占用，脚本会提示修改 `/data/funasr/.env` 或停止占用端口的服务。

## 服务管理

进入运行目录后管理服务：

```bash
cd /data/funasr
docker compose ps
docker compose up -d
docker compose logs -f http-api
docker compose logs -f funasr-server
docker compose down
```

运行目录中的 `README.md` 也会提供常用命令和文档入口。
