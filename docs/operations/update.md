# 更新维护

不同变更对应不同更新方式，避免不必要的重建。

## 修改 HTTP API 配置

涉及文件：

```text
deploy/config/http-api.env
```

更新方式：

```bash
docker compose -f deploy/docker-compose.yml up -d http-api
```

## 修改热词

涉及文件：

```text
deploy/config/hotwords.txt
```

更新方式：

```bash
docker compose -f deploy/docker-compose.yml restart funasr-server
```

## 修改 FunASR 启动脚本

涉及文件：

```text
deploy/config/start-funasr.sh
```

更新方式：

```bash
docker compose -f deploy/docker-compose.yml restart funasr-server
```

## 修改 HTTP API 代码

涉及目录：

```text
components/http-api
```

更新方式：

```bash
docker compose -f deploy/docker-compose.yml build http-api
docker compose -f deploy/docker-compose.yml up -d http-api
```

## 修改 FunASR Server 镜像构建

涉及目录：

```text
components/funasr-server
```

更新方式：

```bash
docker compose -f deploy/docker-compose.yml build funasr-server
docker compose -f deploy/docker-compose.yml up -d funasr-server
```

## 更新模型

涉及目录：

```text
deploy/models
```

建议先停止服务，替换模型后再启动：

```bash
docker compose -f deploy/docker-compose.yml down
docker compose -f deploy/docker-compose.yml up -d
```
