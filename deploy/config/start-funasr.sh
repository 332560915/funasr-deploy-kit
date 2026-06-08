#!/usr/bin/env bash
set -euo pipefail

exec /workspace/FunASR/runtime/websocket/build/bin/funasr-wss-server \
  --download-model-dir /workspace/models \
  --model-dir /workspace/models/damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx \
  --vad-dir /workspace/models/damo/speech_fsmn_vad_zh-cn-16k-common-onnx \
  --punc-dir /workspace/models/damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx \
  --itn-dir /workspace/models/thuduj12/fst_itn_zh \
  --lm-dir /workspace/models/damo/speech_ngram_lm_zh-cn-ai-wesp-fst \
  --decoder-thread-num "${FUNASR_DECODER_THREAD_NUM:-28}" \
  --model-thread-num "${FUNASR_MODEL_THREAD_NUM:-1}" \
  --io-thread-num "${FUNASR_IO_THREAD_NUM:-2}" \
  --port "${FUNASR_PORT:-10095}" \
  --certfile "${FUNASR_CERTFILE:-}" \
  --keyfile "${FUNASR_KEYFILE:-}" \
  --hotword /workspace/config/hotwords.txt
