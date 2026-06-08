# 离线打包

本文说明如何在有网络的环境中打包离线部署材料。

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

默认输出：

```text
dist/funasr-images.tar
dist/funasr-runtime-data.tgz
```

也可以指定输出目录：

```bash
bash scripts/package-offline.sh /data/offline-package
```

## 产物说明

- `funasr-images.tar`: Docker 镜像包，包含 HTTP API 和 FunASR Server 镜像。
- `funasr-runtime-data.tgz`: 运行目录包，包含 Compose 文件、配置、热词、启动脚本和模型目录。

## 校验

```bash
sha256sum dist/funasr-images.tar dist/funasr-runtime-data.tgz
```
