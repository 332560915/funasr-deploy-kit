#!/usr/bin/env bash
set -euo pipefail

# FunASR Server 启动脚本。
#
# 目录约定：
# - /workspace/models  由宿主机 ./models 挂载，存放 FunASR 模型。
# - /workspace/config  由宿主机 ./config 挂载，存放启动脚本和热词文件。
#
# 常用可覆盖环境变量：
# - FUNASR_PORT                服务端口，默认 10095。
# - FUNASR_DECODER_THREAD_NUM  解码线程数，默认 28。
# - FUNASR_MODEL_THREAD_NUM    模型线程数，默认 1。
# - FUNASR_IO_THREAD_NUM       IO 线程数，默认 2。
# - FUNASR_CERTFILE            SSL 证书路径，默认空，表示不启用 SSL。
# - FUNASR_KEYFILE             SSL 私钥路径，默认空，表示不启用 SSL。

set -- /workspace/FunASR/runtime/websocket/build/bin/funasr-wss-server

# 模型下载和缓存根目录。当前部署要求模型已提前放到 /workspace/models。
set -- "$@" --download-model-dir /workspace/models

# ASR 主模型目录。
set -- "$@" --model-dir /workspace/models/damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx

# VAD 语音活动检测模型目录。
set -- "$@" --vad-dir /workspace/models/damo/speech_fsmn_vad_zh-cn-16k-common-onnx

# 标点模型目录。
set -- "$@" --punc-dir /workspace/models/damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx

# ITN 逆文本归一化模型目录。
set -- "$@" --itn-dir /workspace/models/thuduj12/fst_itn_zh

# 语言模型目录。
set -- "$@" --lm-dir /workspace/models/damo/speech_ngram_lm_zh-cn-ai-wesp-fst

# 解码线程数。
set -- "$@" --decoder-thread-num "${FUNASR_DECODER_THREAD_NUM:-28}"

# 模型线程数。
set -- "$@" --model-thread-num "${FUNASR_MODEL_THREAD_NUM:-1}"

# IO 线程数。
set -- "$@" --io-thread-num "${FUNASR_IO_THREAD_NUM:-2}"

# websocket 服务端口。
set -- "$@" --port "${FUNASR_PORT:-10095}"

# SSL 证书路径，空值表示不启用 SSL。
set -- "$@" --certfile "${FUNASR_CERTFILE:-}"

# SSL 私钥路径，空值表示不启用 SSL。
set -- "$@" --keyfile "${FUNASR_KEYFILE:-}"

# 热词文件路径。热词运行文件建议只保留“热词 权重”数据行。
set -- "$@" --hotword /workspace/config/hotwords.txt

exec "$@"
