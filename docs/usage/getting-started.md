# 快速开始

本文用于在有网络的环境中快速构建并启动整个平台。

## 前置条件

- 已安装 Docker。
- 已安装 Docker Compose v2。
- 已准备 FunASR 模型目录，并放到 `deploy/models`。

## 准备配置

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
vi deploy/config/http-api.env
```

重点确认：

```env
FUNASR_WS_URL=ws://funasr-server:10095
UPLOAD_TEMP_DIR=/app/tmp
LOG_FILE=/app/logs/http-api.log
```

## 构建并启动

```bash
docker compose -f deploy/docker-compose.yml build
docker compose -f deploy/docker-compose.yml up -d
```

也可以使用脚本：

```bash
bash scripts/build.sh
docker compose -f deploy/docker-compose.yml up -d
```

## 验证

```bash
curl http://127.0.0.1:18000/health
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

更多部署操作见 [启动部署](../deployment/deploy.md)。
