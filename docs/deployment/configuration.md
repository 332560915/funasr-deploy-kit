# 配置说明

配置分为两类：

- HTTP API 配置：`deploy/config/http-api.env`
- FunASR Server 启动配置：`deploy/config/start-funasr.sh`

## HTTP API 配置

从样例复制：

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
```

关键配置：

```env
APP_NAME=FunASR HTTP API
API_PREFIX=/api/v1
FUNASR_WS_URL=ws://funasr-server:10095
FUNASR_MODE=offline
FUNASR_FINAL_TIMEOUT=120
REQUEST_TIMEOUT=360
TIMEOUT_KEEP_ALIVE=360
HTTP_API_WORKERS=1
HTTP_API_LIMIT_CONCURRENCY=20
HTTP_API_LIMIT_MAX_REQUESTS=1000
HTTP_API_BACKLOG=256
ASR_RECOGNITION_CONCURRENCY=10
MAX_UPLOAD_SIZE=31457280
UPLOAD_TEMP_DIR=/app/tmp
LOG_FILE=/app/logs/http-api.log
```

常用说明：

- `FUNASR_WS_URL`: HTTP API 连接 FunASR Server 的 websocket 地址。
- `FUNASR_MODE`: 当前面向文件转写，默认使用 `offline`。
- `FUNASR_FINAL_TIMEOUT`: 等待 FunASR final 结果的超时时间。
- `REQUEST_TIMEOUT`: HTTP 请求整体超时时间。
- `TIMEOUT_KEEP_ALIVE`: HTTP keep-alive 连接保持时间。
- `HTTP_API_WORKERS`: HTTP API worker 进程数。当前异步模型默认单进程。
- `HTTP_API_LIMIT_CONCURRENCY`: HTTP 层最大并发连接/任务数，用于保护 HTTP 入口。
- `HTTP_API_LIMIT_MAX_REQUESTS`: 单个 worker 处理达到该请求数后重启，降低长期运行风险。
- `HTTP_API_BACKLOG`: TCP 等待队列大小，用于吸收瞬时连接峰值。
- `ASR_RECOGNITION_CONCURRENCY`: 同时允许进入 FunASR 识别的业务并发数，默认 10。
- `MAX_UPLOAD_SIZE`: 同步识别接口上传文件大小上限，单位为字节。默认样例为 30MB。
- `UPLOAD_TEMP_DIR`: 容器内上传临时目录。
- `LOG_FILE`: 容器内日志文件路径。

## FunASR Server 配置

FunASR Server 通过 `deploy/config/start-funasr.sh` 启动。该脚本中配置模型路径、热词路径、线程数和端口。

热词文件：

```text
deploy/config/hotwords.txt
```

带中文注释的热词样例：

```text
deploy/config/hotwords.example.txt
```

`hotwords.txt` 建议只保留实际热词数据行，避免 FunASR 热词解析器不支持注释。

模型目录挂载到容器内：

```text
/workspace/models
```

热词和启动脚本挂载到容器内：

```text
/workspace/config
```
