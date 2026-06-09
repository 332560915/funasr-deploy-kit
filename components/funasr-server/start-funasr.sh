#!/usr/bin/env bash
set -euo pipefail

# FunASR Server 启动脚本。
#
# 本脚本借鉴官方 runtime/run_server.sh 的参数组织方式，但使用 exec 前台运行，
# 让 funasr-wss-server 成为容器主进程，便于 Docker 管理生命周期和日志。
#
# 目录约定：
# - /workspace/models  由宿主机 runtime/models 挂载，存放或缓存 FunASR 模型。
# - /workspace/config  由宿主机 runtime/config 挂载，存放热词等外置配置文件。
#
# 常用可覆盖环境变量：
# - FUNASR_DOWNLOAD_MODEL_DIR  模型下载和缓存目录，默认 /workspace/models。
# - FUNASR_ASR_MODEL           ASR 主模型，默认使用 ModelScope 模型 ID。
# - FUNASR_VAD_MODEL           VAD 模型，默认使用 ModelScope 模型 ID。
# - FUNASR_PUNC_MODEL          标点模型，默认使用 ModelScope 模型 ID。
# - FUNASR_ITN_MODEL           ITN 模型，默认使用 ModelScope 模型 ID。
# - FUNASR_LM_MODEL            语言模型，默认使用 ModelScope 模型 ID。
# - FUNASR_PORT                服务端口，默认 10095。
# - FUNASR_DECODER_THREAD_NUM  解码线程数，默认按 CPU 核数自动计算。
# - FUNASR_MODEL_THREAD_NUM    模型线程数，默认 1。
# - FUNASR_IO_THREAD_NUM       IO 线程数，默认按解码线程数自动计算。
# - FUNASR_CERTFILE            SSL 证书路径，默认空，表示不启用 SSL。
# - FUNASR_KEYFILE             SSL 私钥路径，默认空，表示不启用 SSL。
# - FUNASR_HOTWORD             热词文件路径，默认 /workspace/config/hotwords.txt。

cmd_path="/workspace/FunASR/runtime/websocket/build/bin"
cmd="funasr-wss-server"

# 默认模型。值可以是 ModelScope 模型 ID，也可以是容器内本地模型路径。
download_model_dir="${FUNASR_DOWNLOAD_MODEL_DIR:-/workspace/models}"
model_dir="${FUNASR_ASR_MODEL:-damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx}"
vad_dir="${FUNASR_VAD_MODEL:-damo/speech_fsmn_vad_zh-cn-16k-common-onnx}"
punc_dir="${FUNASR_PUNC_MODEL:-damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx}"
itn_dir="${FUNASR_ITN_MODEL:-thuduj12/fst_itn_zh}"
lm_dir="${FUNASR_LM_MODEL:-damo/speech_ngram_lm_zh-cn-ai-wesp-fst}"

port="${FUNASR_PORT:-10095}"
certfile="${FUNASR_CERTFILE:-}"
keyfile="${FUNASR_KEYFILE:-}"
hotword="${FUNASR_HOTWORD:-/workspace/config/hotwords.txt}"

if [ -n "${FUNASR_DECODER_THREAD_NUM:-}" ]; then
  decoder_thread_num="$FUNASR_DECODER_THREAD_NUM"
else
  decoder_thread_num="$(grep -c '^processor' /proc/cpuinfo 2>/dev/null || true)"
  if [ -z "$decoder_thread_num" ] || [ "$decoder_thread_num" -le 0 ]; then
    echo "Get cpuinfo failed. Set decoder_thread_num = 32"
    decoder_thread_num=32
  fi
fi

model_thread_num="${FUNASR_MODEL_THREAD_NUM:-1}"

if [ -n "${FUNASR_IO_THREAD_NUM:-}" ]; then
  io_thread_num="$FUNASR_IO_THREAD_NUM"
else
  multiple_io=16
  io_thread_num=$(( (decoder_thread_num + multiple_io - 1) / multiple_io ))
fi

# 兼容官方脚本的参数覆盖方式，例如：
# docker run ... local/funasr-runtime-sdk-cpu:0.4.7-is-final --port 10096 --model-dir damo/xxx
parse_options="/workspace/FunASR/runtime/tools/utils/parse_options.sh"
if [ -f "$parse_options" ]; then
  set +u
  . "$parse_options"
  set -u
fi

if [ -z "$certfile" ] || [ "$certfile" = "0" ]; then
  certfile=""
  keyfile=""
fi

mkdir -p "$download_model_dir" /workspace/.config

server_config="{\"server\":[{\"exec\":\"${cmd_path}/${cmd}\",\"--download-model-dir\":\"${download_model_dir}\",\"--model-dir\":\"${model_dir}\",\"--vad-dir\":\"${vad_dir}\",\"--punc-dir\":\"${punc_dir}\",\"--itn-dir\":\"${itn_dir}\",\"--lm-dir\":\"${lm_dir}\",\"--decoder-thread-num\":\"${decoder_thread_num}\",\"--model-thread-num\":\"${model_thread_num}\",\"--io-thread-num\":\"${io_thread_num}\",\"--port\":\"${port}\",\"--certfile\":\"${certfile}\",\"--keyfile\":\"${keyfile}\",\"--hotword\":\"${hotword}\"}]}"
echo "$server_config" > /workspace/.config/server_config

exec "${cmd_path}/${cmd}" \
  --download-model-dir "$download_model_dir" \
  --model-dir "$model_dir" \
  --vad-dir "$vad_dir" \
  --punc-dir "$punc_dir" \
  --itn-dir "$itn_dir" \
  --lm-dir "$lm_dir" \
  --decoder-thread-num "$decoder_thread_num" \
  --model-thread-num "$model_thread_num" \
  --io-thread-num "$io_thread_num" \
  --port "$port" \
  --certfile "$certfile" \
  --keyfile "$keyfile" \
  --hotword "$hotword"
