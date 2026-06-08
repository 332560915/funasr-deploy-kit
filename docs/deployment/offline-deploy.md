# 离线部署说明

离线环境只负责加载镜像和启动容器，不建议在离线服务器上重新构建镜像。应先在有网络的环境中完成构建和验证，再使用脚本导出镜像包和运行目录。

## 在线环境打包

先确认运行配置已经准备好：

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
vi deploy/config/http-api.env
```

构建镜像：

```bash
bash scripts/build.sh
```

打包离线材料：

```bash
bash scripts/package-offline.sh
```

默认输出：

```text
dist/funasr-images.tar
dist/funasr-runtime-data.tgz
```

`package-offline.sh` 会检查 `deploy/config/http-api.env` 是否存在。这个文件不会提交到仓库，需要在打包前从 `.example` 复制并确认配置。

脚本也会检查 `deploy/models` 是否存在且非空。离线环境无法下载模型，因此打包前必须先把 FunASR 模型目录放到 `deploy/models`。

## 离线环境导入

把下面两个文件复制到离线服务器同一个目录，例如 `/data`：

```text
funasr-images.tar
funasr-runtime-data.tgz
```

执行加载脚本：

```bash
bash scripts/load-offline.sh /data
```

脚本会完成：

- 导入 Docker 镜像。
- 解压运行目录到 `/data/funasr`。
- 创建日志和临时目录。
- 启动 `docker-compose.offline.yml`。

## 验证

```bash
cd /data/funasr
docker compose -f docker-compose.offline.yml ps
curl http://127.0.0.1:18000/health
curl -F "file=@/data/funasr/models/audio/test.mp4" http://127.0.0.1:18000/api/v1/asr
```
