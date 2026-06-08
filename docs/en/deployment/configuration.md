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

FunASR Server is started by `deploy/config/start-funasr.sh`. The script configures model paths, hotword paths, thread count, and port.

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
