# 常见问题

## Docker 不可用

现象：

```text
错误：Docker 不可用，请启动 Docker 或检查当前用户权限。
```

检查：

```bash
docker info
```

如果是权限问题，需要把当前用户加入 Docker 用户组，或使用具备 Docker 权限的用户执行。

## Docker Compose 不可用

现象：

```text
错误：Docker Compose v2 不可用，请安装 docker compose 插件。
```

检查：

```bash
docker compose version
```

## rsync 缺失

`package-offline.sh` 复制工程资料时会使用 `rsync` 和 `.gitignore` 排除不需要的文件。打包机需要安装：

```bash
rsync --version
```

离线安装目标机不需要 `rsync`。

## 端口冲突

部署和离线安装会在启动前检查：

```text
FUNASR_HOST_PORT
HTTP_API_PORT
```

如果端口被占用，会提示修改运行目录 `.env`：

```text
/data/funasr/.env
```

或停止占用该端口的服务。

## 镜像不存在

使用 `--no-build` 时，本机必须已经存在所需镜像。检查：

```bash
docker images
```

缺少镜像时，去掉 `--no-build` 重新执行对应脚本。

## 模型缺失

离线打包要求：

```text
deploy-template/models
```

存在且非空。离线环境无法下载模型，必须在打包前准备好模型。

## HTTP API 无法连接 FunASR Server

检查配置：

```text
/data/funasr/runtime/config/http-api.env
```

应为：

```env
FUNASR_WS_URL=ws://funasr-server:10095
```

检查日志：

```bash
cd /data/funasr
docker compose logs -f funasr-server
docker compose logs -f http-api
```

## 上传文件过大

默认上传上限为 30MB。超过限制会返回 `413`。

修改：

```text
/data/funasr/runtime/config/http-api.env
```

然后执行：

```bash
bash scripts/update.sh config /data/funasr
```

## 识别超时

同步接口会等待上传、转发、识别和返回。可以根据实际环境调整：

```env
FUNASR_FINAL_TIMEOUT=120
REQUEST_TIMEOUT=360
TIMEOUT_KEEP_ALIVE=360
```

配置文件：

```text
/data/funasr/runtime/config/http-api.env
```

## 官方客户端等待 final 结果

FunASR offline websocket server 需要返回 `is_final=true`。本项目的 FunASR Server 镜像已经包含兼容补丁。

背景说明见 [FunASR final 消息说明](../reference/funasr-is-final.md)。
