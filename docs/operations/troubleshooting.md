# 常见问题

## HTTP API 无法连接 FunASR Server

检查 `deploy/config/http-api.env`：

```env
FUNASR_WS_URL=ws://funasr-server:10095
```

检查容器状态：

```bash
docker compose -f deploy/docker-compose.yml ps
docker compose -f deploy/docker-compose.yml logs -f funasr-server
```

## 官方客户端等待 final 结果

FunASR offline websocket server 需要返回 `is_final=true`。本项目的 FunASR Server 镜像已经在构建时 patch 该行为。

背景说明见 [FunASR final 消息说明](../reference/funasr-is-final.md)。

## 离线环境启动时提示找不到镜像

先导入镜像包：

```bash
docker load -i funasr-images.tar
```

然后使用离线 Compose 文件启动：

```bash
docker compose -f docker-compose.offline.yml up -d
```

## 打包离线材料失败

`scripts/package-offline.sh` 会检查：

- `deploy/config/http-api.env` 是否存在。
- `deploy/models` 是否存在且非空。

按提示补齐后重新执行打包。

## 上传文件过大

HTTP API 通过 `MAX_UPLOAD_SIZE` 控制同步接口上传大小。默认样例为 30MB，超过限制会返回 `413`。

配置位置：

```text
deploy/config/http-api.env
```

## 并发请求较多时响应变慢

可以根据机器资源和 FunASR Server 承载能力调整：

```env
HTTP_API_LIMIT_CONCURRENCY=20
ASR_RECOGNITION_CONCURRENCY=10
```

`HTTP_API_LIMIT_CONCURRENCY` 控制 HTTP 入口并发，`ASR_RECOGNITION_CONCURRENCY` 控制真正进入 FunASR 识别的业务并发。
