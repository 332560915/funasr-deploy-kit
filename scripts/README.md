# 脚本说明

本目录只保留 Linux/macOS 可用的 shell 脚本，生产离线部署目标按 Linux 服务器处理。

脚本会根据自身位置定位仓库根目录，不依赖执行命令时所在的当前目录。

## 脚本列表

```text
build.sh             构建 Compose 中定义的镜像
package-offline.sh   生成完整离线交付包
load-offline.sh      从离线数据目录导入镜像并启动服务
```

## 快速用法

```bash
bash scripts/build.sh
bash scripts/package-offline.sh
bash scripts/load-offline.sh ../offline-data /data
```

离线交付包解压后，推荐使用外层安装入口：

```bash
bash install.sh
bash install.sh /opt
```

## 相关文档

- [构建镜像](../docs/zh/deployment/build.md)
- [离线打包](../docs/zh/deployment/offline-package.md)
- [离线部署](../docs/zh/deployment/offline-deploy.md)
