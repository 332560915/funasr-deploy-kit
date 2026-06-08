# 快速开始

本文面向第一次拿到项目的使用者，说明如何克隆项目、准备环境、处理模型、构建镜像、启动服务并完成验证。

如果目标机器完全不能联网，不建议走本文流程，请直接看 [离线部署](../deployment/offline-deploy.md)。

## 克隆项目

```bash
git clone https://github.com/332560915/funasr-deploy-kit.git
cd funasr-deploy-kit
```

如果是从压缩包获取源码，解压后进入项目根目录即可。

## 环境要求

- Linux 服务器，或可运行 Docker 的本地 Linux/macOS 环境。
- 已安装 Docker。
- 已安装 Docker Compose v2，命令形式为 `docker compose`。
- 构建镜像时需要能访问 Docker 镜像源。
- 如果没有提前准备模型，首次启动 FunASR Server 时需要能访问模型下载源。

检查命令：

```bash
docker --version
docker compose version
```

## 模型说明

默认使用以下模型：

```text
ASR  主模型：damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx
VAD  模型：  damo/speech_fsmn_vad_zh-cn-16k-common-onnx
PUNC 标点：  damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx
ITN  模型：  thuduj12/fst_itn_zh
LM   语言模型：damo/speech_ngram_lm_zh-cn-ai-wesp-fst
```

模型缓存目录：

```text
deploy/models
```

容器内挂载路径：

```text
/workspace/models
```

### 方式一：联网自动下载

如果 `deploy/models` 为空，但服务器可以联网，FunASR Server 启动时会根据 `deploy/config/start-funasr.sh` 中的模型 ID 下载模型，并缓存到 `deploy/models`。

这种方式适合快速体验和开发环境。首次启动会比较慢，取决于网络和模型下载速度。

### 方式二：提前准备本地模型

如果你已经下载好模型，放到 `deploy/models` 下即可。离线环境必须使用这种方式，或者使用本项目生成的离线运行包。

当需要固定模型路径时，可以修改 `deploy/config/start-funasr.sh` 中的模型变量，例如：

```bash
FUNASR_ASR_MODEL=/workspace/models/damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx
FUNASR_VAD_MODEL=/workspace/models/damo/speech_fsmn_vad_zh-cn-16k-common-onnx
FUNASR_PUNC_MODEL=/workspace/models/damo/punc_ct-transformer_cn-en-common-vocab471067-large-onnx
FUNASR_ITN_MODEL=/workspace/models/thuduj12/fst_itn_zh
FUNASR_LM_MODEL=/workspace/models/damo/speech_ngram_lm_zh-cn-ai-wesp-fst
```

模型参数的详细说明见 [配置说明](../deployment/configuration.md)。

## 准备配置

复制 HTTP API 配置样例：

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
```

一般情况下，快速体验不需要修改配置。重点配置如下：

```env
FUNASR_WS_URL=ws://funasr-server:10095
UPLOAD_TEMP_DIR=/app/tmp
LOG_FILE=/app/logs/http-api.log
MAX_UPLOAD_SIZE=31457280
```

如果需要调整端口、上传大小、并发或超时时间，见 [配置说明](../deployment/configuration.md)。

## 构建镜像

推荐使用脚本：

```bash
bash scripts/build.sh
```

等价于：

```bash
docker compose -f deploy/docker-compose.yml build
```

## 启动服务

```bash
docker compose -f deploy/docker-compose.yml up -d
```

查看容器状态：

```bash
docker compose -f deploy/docker-compose.yml ps
```

查看启动日志：

```bash
docker compose -f deploy/docker-compose.yml logs -f funasr-server
docker compose -f deploy/docker-compose.yml logs -f http-api
```

## 验证服务

健康检查：

```bash
curl http://127.0.0.1:18000/health
```

浏览器打开 Swagger 文档：

```text
http://127.0.0.1:18000/docs
```

如果部署在服务器上，将 `127.0.0.1` 替换为服务器 IP。

上传音频或视频文件识别：

```bash
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

同步接口默认上传上限为 30MB，建议使用短音频或小文件完成首次验证。

## 下一步

- 查看接口说明：[HTTP API 调用](api.md)
- 调整配置：[配置说明](../deployment/configuration.md)
- 生成离线包：[离线打包](../deployment/offline-package.md)
- 在无网络环境部署：[离线部署](../deployment/offline-deploy.md)
- 排查问题：[常见问题](../operations/troubleshooting.md)
