# 离线部署

本文面向无网络环境。离线环境只负责加载镜像、还原运行目录和启动容器，不在目标机器重新构建镜像。

## 准备离线包

先在有网络的环境制作离线包：

```bash
bash scripts/package-offline.sh
```

生成：

```text
dist/funasr-deploy-kit-offline.tar.gz
```

把该压缩包传到离线服务器。

## 解压离线包

```bash
tar -xzf funasr-deploy-kit-offline.tar.gz
cd funasr-deploy-kit-offline
```

## 执行安装

默认安装到 `/data/funasr`：

```bash
bash install.sh
```

安装到 `/opt/funasr`：

```bash
bash install.sh /opt
```

注意：外层 `install.sh` 的参数是安装根目录，`bash install.sh /opt` 表示最终安装到 `/opt/funasr`。

自动确认安装：

```bash
bash install.sh /opt --yes
```

## 安装过程

安装脚本会执行：

- 校验 `offline-data/SHA256SUMS.txt`。
- `docker load` 导入镜像。
- 如果目标运行目录已存在，先停止旧服务并备份旧目录。
- 还原运行数据到 `runtime/`。
- 复制 `docker-compose.yml`、`.env` 和运行目录 `README.md`。
- 启动前检查 `FUNASR_HOST_PORT` 和 `HTTP_API_PORT`。
- 启动服务。

## 安装结果

默认运行目录：

```text
/data/funasr/
|-- docker-compose.yml
|-- .env
|-- README.md
|-- README.en.md
`-- runtime/
```

`funasr-deploy-kit/` 是工程资料目录，包含脚本、文档和源码。安装完成后，如果只需要运行服务，可以删除该目录。

## 验证服务

```bash
cd /data/funasr
docker compose ps
curl http://127.0.0.1:18000/health
```

Swagger 测试页面：

```text
http://127.0.0.1:18000/docs
```

上传文件识别：

```bash
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

底层安装脚本也可以直接调用：

```bash
cd funasr-deploy-kit
bash scripts/install-offline.sh ../offline-data /data/funasr
```
