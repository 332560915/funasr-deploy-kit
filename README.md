# funasr-deploy-kit

[English](README.en.md)

`funasr-deploy-kit` 是一个面向 FunASR 服务化部署的 Docker 工程，提供 FunASR websocket 服务封装、HTTP 文件识别 API、配置与热词挂载、离线打包迁移、启动更新脚本和中文部署文档，适用于内网或无公网环境中的语音转文字服务交付。

## 支持场景

- 文件上传式语音转文字，默认同步接口为 `POST /api/v1/asr`，适合短音频和功能验证。
- HTTP API 内置 Swagger 文档，可通过 `/docs` 在浏览器中测试和联调。
- FunASR offline websocket 服务容器化部署。
- 模型、热词、配置、日志和临时文件目录外置挂载。
- 在线环境构建镜像，离线环境导入镜像并启动。
- 后续可扩展独立 websocket 转发组件或异步任务识别接口。

## 工程结构

```text
.
|-- components/
|   |-- http-api/           文件上传式 HTTP API 组件
|   `-- funasr-server/      FunASR websocket 服务端组件
|-- deploy/                 Compose 文件和部署配置样例
|-- scripts/                构建、打包和离线加载脚本
`-- docs/
    |-- zh/                 中文文档
    `-- en/                 English documentation
```

## 中文文档

- [快速开始](docs/zh/usage/getting-started.md)
- [HTTP API 调用](docs/zh/usage/api.md)
- [配置说明](docs/zh/deployment/configuration.md)
- [构建镜像](docs/zh/deployment/build.md)
- [启动部署](docs/zh/deployment/deploy.md)
- [更新维护](docs/zh/operations/update.md)
- [离线打包](docs/zh/deployment/offline-package.md)
- [离线部署](docs/zh/deployment/offline-deploy.md)
- [常见问题](docs/zh/operations/troubleshooting.md)
- [FunASR final 消息说明](docs/zh/reference/funasr-is-final.md)
- [下一版本规划](docs/zh/reference/next-version-plan.md)
- [版本变更记录](CHANGELOG.md)

## 组件入口

- [HTTP API 组件](components/http-api/README.md)
- [FunASR Server 组件](components/funasr-server/README.md)
- [部署目录说明](deploy/README.md)
- [脚本说明](scripts/README.md)
