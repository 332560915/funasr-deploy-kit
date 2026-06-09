# 脚本说明

本目录只保留 Linux/macOS 可用的 shell 脚本，生产离线部署目标按 Linux 服务器处理。

脚本会根据自身位置定位仓库根目录，不依赖执行命令时所在的当前目录。

## 场景脚本

```text
quick-start.sh       第一次快速跑通：构建镜像、生成运行目录、启动服务、输出验证命令
deploy-online.sh     在线正式部署：生成独立运行目录，可选择是否构建和启动
package-offline.sh   在线环境制作离线交付包
install-offline.sh   离线环境安装入口，通常由离线包外层 install.sh 调用
update.sh            服务运行后的更新入口，按变更类型更新配置、镜像、模型或 Compose
lib/                 内部公共函数，不作为用户入口
```

## 递进用法

第一次跑通：

```bash
bash scripts/quick-start.sh
```

在线正式部署：

```bash
bash scripts/deploy-online.sh /data/funasr
```

制作离线包：

```bash
bash scripts/package-offline.sh
```

离线包解压后安装：

```bash
bash install.sh
bash install.sh /opt
```

更新 HTTP API：

```bash
bash scripts/update.sh http-api /data/funasr
```

## 相关文档

- [快速开始](../docs/zh/usage/getting-started.md)
- [在线部署](../docs/zh/deployment/deploy.md)
- [离线打包](../docs/zh/deployment/offline-package.md)
- [离线部署](../docs/zh/deployment/offline-deploy.md)
- [更新维护](../docs/zh/operations/update.md)
