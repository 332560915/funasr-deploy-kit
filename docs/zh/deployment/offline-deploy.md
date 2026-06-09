# 离线部署说明

离线环境只负责加载镜像和启动容器，不建议在离线服务器上重新构建镜像。应先在有网络的环境中完成构建和验证，再生成完整离线包。

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
dist/funasr-deploy-kit-offline.tar.gz
```

`package-offline.sh` 会检查 `deploy/config/http-api.env` 是否存在。这个文件不会提交到仓库，需要在打包前从 `.example` 复制并确认配置。

脚本也会检查 `deploy/models` 是否存在且非空。离线环境无法下载模型，因此打包前必须先把 FunASR 模型目录放到 `deploy/models`。

## 离线环境安装

把 `funasr-deploy-kit-offline.tar.gz` 复制到离线服务器，解压：

```bash
tar -xzf funasr-deploy-kit-offline.tar.gz
cd funasr-deploy-kit-offline
```

默认安装到 `/data/funasr`：

```bash
bash install.sh
```

安装到 `/opt/funasr`：

```bash
bash install.sh /opt
```

安装脚本会显示：

```text
离线数据目录
工程目录
安装根目录
最终部署目录
```

并询问是否继续安装。需要自动确认时可以使用：

```bash
bash install.sh /opt --yes
```

底层加载脚本也可以直接调用：

```bash
cd funasr-deploy-kit
bash scripts/load-offline.sh ../offline-data /data
```

参数含义：

```text
第一个参数：离线数据目录，默认是工程目录相邻的 ../offline-data
第二个参数：安装根目录，默认是 /data
最终部署目录：安装根目录/funasr
```

## 验证

```bash
cd /data/funasr
docker compose -f docker-compose.offline.yml ps
curl http://127.0.0.1:18000/health
curl -F "file=@/data/funasr/models/audio/test.mp4" http://127.0.0.1:18000/api/v1/asr
```
