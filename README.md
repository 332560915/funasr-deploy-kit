# FunASR 语音识别平台

本仓库交付一套本地化语音识别平台：使用容器运行 FunASR websocket 服务，并提供文件上传式 HTTP API。调用方可以直接上传音频或视频文件，平台返回完整识别文本。

## 支持场景

- 文件上传式语音转文字，默认接口为 `POST /api/v1/asr`。
- HTTP API 内置 Swagger 文档，便于浏览器测试和联调。
- FunASR offline websocket 服务容器化部署。
- 模型、热词、配置、日志和临时文件目录外置挂载。
- 在线环境构建镜像，离线环境导入镜像并启动。
- 未来可扩展独立的 websocket-gateway 组件。

## 平台组成

```text
.
|-- components/
|   |-- http-api/           文件上传式 HTTP API 组件
|   `-- funasr-server/      FunASR websocket 服务端组件
|-- deploy/                 Compose 文件和部署配置样例
|-- scripts/                构建、打包和离线加载脚本
`-- docs/
    |-- usage/              使用入口和 API
    |-- deployment/         构建、部署和离线迁移
    |-- operations/         更新维护和排障
    `-- reference/          背景说明和参考材料
```

## 文档入口

- [快速开始](docs/usage/getting-started.md)
- [HTTP API 调用](docs/usage/api.md)
- [配置说明](docs/deployment/configuration.md)
- [构建镜像](docs/deployment/build.md)
- [启动部署](docs/deployment/deploy.md)
- [更新维护](docs/operations/update.md)
- [离线打包](docs/deployment/offline-package.md)
- [离线部署](docs/deployment/offline-deploy.md)
- [常见问题](docs/operations/troubleshooting.md)
- [FunASR final 消息说明](docs/reference/funasr-is-final.md)
- [版本变更记录](CHANGELOG.md)

## 组件入口

- [HTTP API 组件](components/http-api/README.md)
- [FunASR Server 组件](components/funasr-server/README.md)
- [部署目录说明](deploy/README.md)
- [脚本说明](scripts/README.md)
