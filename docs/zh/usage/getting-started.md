# 快速开始

本文面向第一次拿到项目的使用者，目标是用默认配置快速跑通 FunASR Server 和 HTTP API。

如果目标机器完全不能联网，请直接看 [离线部署](../deployment/offline-deploy.md)。

## 克隆项目

```bash
git clone https://github.com/332560915/funasr-deploy-kit.git
cd funasr-deploy-kit
```

## 环境要求

- Linux 服务器，或可运行 Docker 的 Linux/macOS 环境。
- 已安装 Docker。
- 已安装 Docker Compose v2，命令形式为 `docker compose`。
- 首次构建镜像时能访问 Docker 镜像源。
- 如果没有提前准备模型，首次启动 FunASR Server 时需要能访问模型下载源。

检查命令：

```bash
docker --version
docker compose version
```

## 快速启动

第一次使用不要加 `--no-build`，脚本会自动构建镜像、生成运行目录并启动服务：

```bash
bash scripts/quick-start.sh
```

默认运行目录为：

```text
/data/funasr
```

如需换目录：

```bash
bash scripts/quick-start.sh /opt/funasr
```

## 验证服务

进入运行目录：

```bash
cd /data/funasr
docker compose ps
```

健康检查：

```bash
curl http://127.0.0.1:18000/health
```

Swagger 测试页面：

```text
http://127.0.0.1:18000/docs
```

上传音频或视频文件识别：

```bash
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

同步接口默认上传上限为 30MB，建议使用短音频或小文件完成首次验证。

## 下一步

- 调用接口：[HTTP API 调用](api.md)
- 正式部署：[在线部署](../deployment/deploy.md)
- 调整配置：[配置说明](../deployment/configuration.md)
- 制作离线包：[离线打包](../deployment/offline-package.md)
- 无网环境安装：[离线部署](../deployment/offline-deploy.md)
