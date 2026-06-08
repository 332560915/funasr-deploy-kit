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

FunASR Server 通过 `deploy/config/start-funasr.sh` 启动。该脚本借鉴官方 `runtime/run_server.sh` 的参数组织方式，但使用 `exec` 前台运行，适合 Docker 容器生命周期管理。

脚本支持三种配置方式：

- 修改 `deploy/config/start-funasr.sh` 中的默认变量。
- 通过环境变量覆盖默认值。
- 通过官方 `parse_options.sh` 风格的启动参数覆盖，例如 `--port 10096 --model-dir damo/xxx`。

默认模型：

```text
ASR  主模型：damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx
VAD  模型：  damo/speech_fsmn_vad_zh-cn-16k-common-onnx
PUNC 标点：  damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx
ITN  模型：  thuduj12/fst_itn_zh
LM   语言模型：damo/speech_ngram_lm_zh-cn-ai-wesp-fst
```

模型配置位于 `deploy/config/start-funasr.sh`：

```bash
download_model_dir="${FUNASR_DOWNLOAD_MODEL_DIR:-/workspace/models}"
model_dir="${FUNASR_ASR_MODEL:-damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx}"
vad_dir="${FUNASR_VAD_MODEL:-damo/speech_fsmn_vad_zh-cn-16k-common-onnx}"
punc_dir="${FUNASR_PUNC_MODEL:-damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx}"
itn_dir="${FUNASR_ITN_MODEL:-thuduj12/fst_itn_zh}"
lm_dir="${FUNASR_LM_MODEL:-damo/speech_ngram_lm_zh-cn-ai-wesp-fst}"
```

模型值可以是 ModelScope 模型 ID，也可以是容器内本地模型路径。例如离线环境固定本地模型时，可以改为：

```bash
model_dir="${FUNASR_ASR_MODEL:-/workspace/models/damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx}"
```

模型下载和缓存目录固定为：

```text
/workspace/models
```

该目录由宿主机 `deploy/models` 挂载进入容器。

线程相关参数默认按官方脚本逻辑自动计算：

```text
decoder_thread_num = CPU 核数
io_thread_num      = ceil(decoder_thread_num / 16)
model_thread_num   = 1
```

如需固定线程数，可以通过环境变量覆盖：

```bash
FUNASR_DECODER_THREAD_NUM=28
FUNASR_IO_THREAD_NUM=2
FUNASR_MODEL_THREAD_NUM=1
```

SSL 配置与官方脚本保持一致：`FUNASR_CERTFILE` 为空或 `0` 时关闭 SSL，同时 `FUNASR_KEYFILE` 也会置空。

启动时会生成：

```text
/workspace/.config/server_config
```

该文件用于记录实际启动参数，便于排查运行配置。

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
