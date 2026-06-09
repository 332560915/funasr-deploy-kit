# 配置说明

安装完成后，日常配置应修改运行目录中的文件，而不是修改 `deploy-template/`。

## 配置分类

```text
/data/funasr/.env                         Compose 运行配置
/data/funasr/runtime/config/http-api.env  HTTP API 配置
/data/funasr/runtime/config/hotwords.txt  热词运行文件
```

## Compose 运行配置

文件位置：

```text
/data/funasr/.env
```

常用配置：

```env
FUNASR_SERVER_IMAGE=local/funasr-runtime-sdk-cpu:0.4.7-is-final
HTTP_API_IMAGE=local/http-api:latest

FUNASR_HOST_PORT=10095
FUNASR_SERVER_PORT=10095
HTTP_API_PORT=18000

FUNASR_DOWNLOAD_MODEL_DIR=/workspace/models
FUNASR_ASR_MODEL=damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx
FUNASR_VAD_MODEL=damo/speech_fsmn_vad_zh-cn-16k-common-onnx
FUNASR_PUNC_MODEL=damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx
FUNASR_ITN_MODEL=thuduj12/fst_itn_zh
FUNASR_LM_MODEL=damo/speech_ngram_lm_zh-cn-ai-wesp-fst
FUNASR_HOTWORD=/workspace/config/hotwords.txt
```

说明：

- `FUNASR_SERVER_IMAGE`、`HTTP_API_IMAGE`: 运行镜像名称。
- `FUNASR_HOST_PORT`: FunASR Server 暴露到宿主机的端口。
- `HTTP_API_PORT`: HTTP API 暴露到宿主机的端口。
- `FUNASR_*_MODEL`: 模型 ID 或容器内模型路径。
- `FUNASR_HOTWORD`: 容器内热词文件路径。

## HTTP API 配置

文件位置：

```text
/data/funasr/runtime/config/http-api.env
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

`MAX_UPLOAD_SIZE=31457280` 表示同步接口默认上传上限为 30MB。

## 热词配置

热词运行文件：

```text
/data/funasr/runtime/config/hotwords.txt
```

热词格式参考：

```text
/data/funasr/runtime/config/hotwords.txt.template
```

`hotwords.txt` 是运行文件，只写真实热词数据行：

```text
乡村振兴 20
通义实验室 30
```

`hotwords.txt.template` 可以包含注释。由于官方文档没有说明热词文件支持注释，运行文件不要直接复制模板内容，避免 FunASR 热词解析器误读注释。

修改热词后重启 FunASR Server：

```bash
bash scripts/update.sh hotwords /data/funasr
```

## 修改 FunASR Server 启动逻辑

FunASR Server 启动脚本源码位于：

```text
components/funasr-server/start-funasr.sh
```

修改后重建并更新：

```bash
bash scripts/update.sh funasr-server /data/funasr
```
