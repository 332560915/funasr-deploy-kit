# 更新维护

本文面向服务已经运行后的维护场景，对应脚本：

```text
scripts/update.sh
```

## 修改 HTTP API 配置

配置文件：

```text
/data/funasr/runtime/config/http-api.env
```

更新：

```bash
bash scripts/update.sh config /data/funasr
```

## 修改热词

热词文件：

```text
/data/funasr/runtime/config/hotwords.txt
```

更新：

```bash
bash scripts/update.sh hotwords /data/funasr
```

## 修改 HTTP API 代码

涉及目录：

```text
components/http-api
```

更新会重建 HTTP API 镜像并重启 `http-api`：

```bash
bash scripts/update.sh http-api /data/funasr
```

如果镜像已经提前构建好：

```bash
bash scripts/update.sh http-api /data/funasr --no-build
```

## 修改 FunASR Server

涉及目录：

```text
components/funasr-server
```

适用于修改 Dockerfile、启动脚本、C++ websocket server 补丁等场景：

```bash
bash scripts/update.sh funasr-server /data/funasr
```

如果镜像已经提前构建好：

```bash
bash scripts/update.sh funasr-server /data/funasr --no-build
```

## 更新模型

模型目录：

```text
/data/funasr/runtime/models
```

替换模型后执行：

```bash
bash scripts/update.sh models /data/funasr
```

该场景会先停止整套服务，再检查端口，最后重新启动。

## 更新 Compose 模板

如果修改了：

```text
deploy-template/docker-compose.yml
deploy-template/compose.env.template
deploy-template/README.md
deploy-template/README.en.md
```

同步到运行目录：

```bash
bash scripts/update.sh compose /data/funasr
```

该场景会先停止整套服务，再同步模板、检查端口并重新启动。
