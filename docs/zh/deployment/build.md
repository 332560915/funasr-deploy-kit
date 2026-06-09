# 镜像构建说明

镜像构建已经纳入场景脚本，不再提供单独的用户入口脚本。

## 自动构建场景

快速开始：

```bash
bash scripts/quick-start.sh
```

在线部署：

```bash
bash scripts/deploy-online.sh /data/funasr
```

离线打包：

```bash
bash scripts/package-offline.sh
```

这些脚本默认会构建所需镜像。

## 跳过构建

如果镜像已经存在，可以使用 `--no-build`：

```bash
bash scripts/deploy-online.sh /data/funasr --no-build
bash scripts/package-offline.sh --no-build
```

脚本会提前检查本机 Docker 是否存在所需镜像。缺少镜像时会报错。

## 单组件更新

更新 HTTP API：

```bash
bash scripts/update.sh http-api /data/funasr
```

更新 FunASR Server：

```bash
bash scripts/update.sh funasr-server /data/funasr
```

## 镜像名来源

镜像名来自：

```text
deploy-template/compose.env.template
```

默认值：

```env
FUNASR_SERVER_IMAGE=local/funasr-runtime-sdk-cpu:0.4.7-is-final
HTTP_API_IMAGE=local/http-api:latest
```

构建、启动和离线打包都读取同一份模板，避免不同场景使用不同镜像名。

## 缓存说明

Docker 会按层复用缓存。HTTP API 镜像会先安装依赖，再复制业务代码，因此只修改 Python 业务代码时通常不会重新安装依赖。

FunASR Server 镜像会编译 `funasr-wss-server`。基础镜像、Dockerfile 和相关源码不变时，编译层通常可以复用缓存。
