# Third-Party Notices

This project packages deployment utilities and service wrappers for a FunASR-based speech recognition service. The project code in this repository is licensed under Apache License 2.0, but third-party projects, images, model files, and dependencies keep their own upstream license terms.

## FunASR

- Upstream project: https://github.com/modelscope/FunASR
- Related upstream project URL also used by source headers: https://github.com/alibaba-damo-academy/FunASR
- Upstream license: MIT License, according to the copyright notice retained in `components/funasr-server/src/websocket-server.cpp`.
- Derived file in this repository: `components/funasr-server/src/websocket-server.cpp`.

The derived C++ file keeps the original FunASR copyright and MIT License notice. This project adds a modification notice for the local `is_final` compatibility change.

## Container Images

This project references third-party base images, including:

- `registry.cn-hangzhou.aliyuncs.com/funasr_repo/funasr:funasr-runtime-sdk-cpu-0.4.7`
- `python:3.12-slim`

Those base images and the software included in them are governed by their respective upstream licenses. Redistributors of built images should keep applicable upstream license notices and review the image contents before public redistribution.

## Model Files

The deployment templates reference FunASR and ModelScope model identifiers, for example:

- `damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx`
- `damo/speech_fsmn_vad_zh-cn-16k-common-onnx`
- `damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx`
- `thuduj12/fst_itn_zh`
- `damo/speech_ngram_lm_zh-cn-ai-wesp-fst`

Model files are not relicensed by this project. Before bundling, redistributing, or using model files in a commercial environment, review the license and usage terms on the corresponding model page.

## Python Dependencies

The HTTP API component uses third-party Python packages, including FastAPI, Uvicorn, Pydantic Settings, Loguru, python-multipart, aiofiles, and `funasr-python`. These dependencies are governed by their respective upstream licenses.

## Offline Packages

Offline packages may contain this project, built container images, cached model files, and dependency artifacts. The Apache License 2.0 applies to this project's own source code and documentation only. It does not replace the license terms of bundled third-party artifacts.
