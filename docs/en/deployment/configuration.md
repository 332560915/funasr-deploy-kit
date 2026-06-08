# Configuration

Configuration is split into two groups:

- HTTP API configuration: `deploy/config/http-api.env`
- FunASR Server startup configuration: `deploy/config/start-funasr.sh`

## HTTP API Configuration

Copy the sample file:

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
```

Important values:

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

Common settings:

- `FUNASR_WS_URL`: Websocket URL used by HTTP API to connect to FunASR Server.
- `FUNASR_MODE`: File transcription uses `offline` by default.
- `FUNASR_FINAL_TIMEOUT`: Timeout for waiting for the final FunASR result.
- `REQUEST_TIMEOUT`: Overall HTTP request timeout.
- `TIMEOUT_KEEP_ALIVE`: HTTP keep-alive timeout.
- `HTTP_API_WORKERS`: Number of HTTP API worker processes. The current async model uses one worker by default.
- `HTTP_API_LIMIT_CONCURRENCY`: Maximum HTTP-level concurrent connections/tasks. It protects the HTTP entrypoint.
- `HTTP_API_LIMIT_MAX_REQUESTS`: Restart a worker after it has processed this many requests to reduce long-running risk.
- `HTTP_API_BACKLOG`: TCP backlog used to absorb short connection spikes.
- `ASR_RECOGNITION_CONCURRENCY`: Business concurrency allowed to enter FunASR recognition. The default is 10.
- `MAX_UPLOAD_SIZE`: Upload size limit for the synchronous transcription API, in bytes. The default sample value is 30MB.
- `UPLOAD_TEMP_DIR`: Temporary upload directory inside the container.
- `LOG_FILE`: Log file path inside the container.

## FunASR Server Configuration

FunASR Server is started by `deploy/config/start-funasr.sh`. The script follows the parameter style of the official `runtime/run_server.sh`, but uses foreground `exec` so it works better as the main Docker container process.

The script supports three configuration methods:

- Change default variables in `deploy/config/start-funasr.sh`.
- Override defaults with environment variables.
- Override values with official `parse_options.sh`-style startup arguments, such as `--port 10096 --model-dir damo/xxx`.

Default models:

```text
ASR  model:          damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx
VAD  model:          damo/speech_fsmn_vad_zh-cn-16k-common-onnx
PUNC model:          damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx
ITN  model:          thuduj12/fst_itn_zh
LM   language model: damo/speech_ngram_lm_zh-cn-ai-wesp-fst
```

Model settings are in `deploy/config/start-funasr.sh`:

```bash
download_model_dir="${FUNASR_DOWNLOAD_MODEL_DIR:-/workspace/models}"
model_dir="${FUNASR_ASR_MODEL:-damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx}"
vad_dir="${FUNASR_VAD_MODEL:-damo/speech_fsmn_vad_zh-cn-16k-common-onnx}"
punc_dir="${FUNASR_PUNC_MODEL:-damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx}"
itn_dir="${FUNASR_ITN_MODEL:-thuduj12/fst_itn_zh}"
lm_dir="${FUNASR_LM_MODEL:-damo/speech_ngram_lm_zh-cn-ai-wesp-fst}"
```

Each model value can be a ModelScope model ID or a local model path inside the container. For example, to pin a local model path in an offline environment:

```bash
model_dir="${FUNASR_ASR_MODEL:-/workspace/models/damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx}"
```

Model download and cache directory:

```text
/workspace/models
```

This directory is mounted from host directory `deploy/models`.

Thread parameters follow the official script's automatic calculation by default:

```text
decoder_thread_num = CPU core count
io_thread_num      = ceil(decoder_thread_num / 16)
model_thread_num   = 1
```

To pin thread values, override them with environment variables:

```bash
FUNASR_DECODER_THREAD_NUM=28
FUNASR_IO_THREAD_NUM=2
FUNASR_MODEL_THREAD_NUM=1
```

SSL behavior matches the official script: when `FUNASR_CERTFILE` is empty or `0`, SSL is disabled and `FUNASR_KEYFILE` is cleared as well.

The startup script writes the effective server arguments to:

```text
/workspace/.config/server_config
```

This file is useful when troubleshooting runtime configuration.

Hotword file:

```text
deploy/config/hotwords.txt
```

Hotword sample with Chinese comments:

```text
deploy/config/hotwords.example.txt
```

`hotwords.txt` should contain only actual hotword data lines because the FunASR hotword parser may not support comments.

The model directory is mounted into the container:

```text
/workspace/models
```

Hotwords and the startup script are mounted into the container:

```text
/workspace/config
```
