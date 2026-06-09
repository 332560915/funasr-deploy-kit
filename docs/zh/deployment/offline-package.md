# 离线打包

本文说明如何在有网络的环境中生成完整离线交付包。

## 前置条件

- 两个镜像已经构建完成。
- `deploy/config/http-api.env` 已经确认。
- `deploy/models` 已经放入 FunASR 模型文件。

## 构建镜像

```bash
bash scripts/build.sh
```

## 打包

```bash
bash scripts/package-offline.sh
```

默认输出目录为 `dist/`，会生成：

```text
dist/funasr-deploy-kit-offline/
dist/funasr-deploy-kit-offline.tar.gz
```

也可以指定输出目录：

```bash
bash scripts/package-offline.sh /data/offline-package
```

## 离线包结构

```text
funasr-deploy-kit-offline/
|-- README.md
|-- README.en.md
|-- install.sh
|-- offline-data/
|   |-- funasr-images.tar
|   |-- funasr-runtime-data.tgz
|   `-- SHA256SUMS.txt
`-- funasr-deploy-kit/
    |-- docs/
    |-- scripts/
    |-- deploy/
    `-- components/
```

## 产物说明

- `funasr-deploy-kit-offline.tar.gz`: 最终交付压缩包，推荐只传递这个文件。
- `install.sh`: 离线安装入口，会提示安装路径并要求确认。
- `offline-data/funasr-images.tar`: Docker 镜像包，包含 HTTP API 和 FunASR Server 镜像。
- `offline-data/funasr-runtime-data.tgz`: 运行目录包，包含 Compose 文件、配置、热词、启动脚本和模型目录。
- `offline-data/SHA256SUMS.txt`: 离线数据校验文件。
- `funasr-deploy-kit/`: 工程目录，包含脚本、文档、部署模板和源码。

## 排除内容

打包工程目录时会排除：

```text
.git/
.idea/
.venv/
components/http-api/.venv/
deploy/models/
deploy/logs/
deploy/tmp/
dist/
dest/
*.tar
*.tgz
*.tar.gz
```

模型不会作为工程源码复制，而是进入 `offline-data/funasr-runtime-data.tgz`。
