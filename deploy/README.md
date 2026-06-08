# 部署目录说明

`deploy` 是运行目录模板，包含 Compose 文件和外置配置样例。生产环境可以把本目录复制到 `/data/funasr`。

## 文件说明

```text
deploy/
|-- docker-compose.yml          在线构建和启动使用
|-- docker-compose.offline.yml  离线环境启动使用
`-- config/
    |-- http-api.env.example    HTTP API 配置样例
    |-- hotwords.txt            热词文件
    |-- hotwords.example.txt    带中文注释的热词样例
    `-- start-funasr.sh         FunASR Server 启动脚本
```

运行时还需要准备：

```text
deploy/models/                 FunASR 模型目录
deploy/logs/http-api/          HTTP API 日志目录
deploy/logs/funasr-server/     FunASR Server 日志目录
deploy/tmp/http-api/           HTTP API 临时上传目录
```

## 相关文档

- [快速开始](../docs/zh/usage/getting-started.md)
- [配置说明](../docs/zh/deployment/configuration.md)
- [启动部署](../docs/zh/deployment/deploy.md)
- [更新维护](../docs/zh/operations/update.md)
- [离线部署](../docs/zh/deployment/offline-deploy.md)
