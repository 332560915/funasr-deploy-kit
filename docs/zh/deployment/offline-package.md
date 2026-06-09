# 离线打包

本文面向有网络的打包环境，对应脚本：

```text
scripts/package-offline.sh
```

## 前置条件

- 已安装 Docker 和 Docker Compose v2。
- 打包机已安装 `rsync`、`tar`、`sha256sum`。
- `deploy-template/config/http-api.env.template` 已经确认。
- `deploy-template/models` 已经放入 FunASR 模型文件。

离线环境不能下载模型，因此 `deploy-template/models` 必须存在且非空。

## 执行打包

默认会先构建镜像，再生成离线包：

```bash
bash scripts/package-offline.sh
```

如果镜像已经存在，可以跳过构建：

```bash
bash scripts/package-offline.sh --no-build
```

`--no-build` 会检查本机是否已有所需镜像。缺少镜像时会提前报错。

指定输出目录：

```bash
bash scripts/package-offline.sh /data/offline-package
```

## 输出结果

默认输出：

```text
dist/funasr-deploy-kit-offline/
dist/funasr-deploy-kit-offline.tar.gz
```

推荐只传递最终压缩包：

```text
funasr-deploy-kit-offline.tar.gz
```

## 离线包结构

```text
funasr-deploy-kit-offline/
|-- README.md
|-- README.en.md
|-- install.sh
|-- offline-data/
|   |-- funasr-images.tar
|   |-- runtime-data.tgz
|   `-- SHA256SUMS.txt
`-- funasr-deploy-kit/
    |-- components/
    |-- deploy-template/
    |-- docs/
    `-- scripts/
```

说明：

- `install.sh`: 离线包外层安装入口，来自 `deploy-template/offline-package/install.sh`。
- `README.md`、`README.en.md`: 离线包说明，来自 `deploy-template/offline-package/`。
- `offline-data/funasr-images.tar`: Docker 镜像包。
- `offline-data/runtime-data.tgz`: 运行数据包，包含 `config/` 和 `models/`。
- `funasr-deploy-kit/`: 工程资料目录，包含脚本、文档、模板和源码。

## 排除规则

复制工程资料时，脚本使用项目根目录 `.gitignore` 作为主要排除规则，并额外排除：

```text
.git/
当前输出目录
```

这样可以避免把 Git 元数据、虚拟环境、模型、日志和生成中的离线包递归复制到工程资料目录。

模型不会作为工程源码复制，而是进入：

```text
offline-data/runtime-data.tgz
```
