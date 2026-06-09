# FunASR Deploy Kit 运行目录说明

这是 `funasr-deploy-kit` 生成的运行目录说明。当前目录用于启动和管理 FunASR Server 与 HTTP API 服务，通常包含：

```text
docker-compose.yml
.env
runtime/
```

## 常用命令

进入运行目录后管理服务：

```bash
docker compose ps
docker compose up -d
docker compose logs -f http-api
docker compose logs -f funasr-server
docker compose down
```

验证 HTTP API：

```bash
curl http://127.0.0.1:18000/health
```

Swagger 测试地址：

```text
http://127.0.0.1:18000/docs
```

## 常用配置

```text
.env                              端口、镜像、模型和挂载路径
runtime/config/http-api.env       HTTP API 配置
runtime/config/hotwords.txt       热词运行文件
runtime/config/hotwords.txt.template  热词格式参考
```

`hotwords.txt` 只写真实热词数据行；`hotwords.txt.template` 是格式参考，可以包含注释。

## 完整技术支持

完整部署、配置、离线迁移和问题排查说明，请查看项目文档：

- [项目首页](https://github.com/332560915/funasr-deploy-kit)
- [中文文档](https://github.com/332560915/funasr-deploy-kit/blob/main/docs/zh/index.md)
- [快速开始](https://github.com/332560915/funasr-deploy-kit/blob/main/docs/zh/usage/getting-started.md)
- [在线部署](https://github.com/332560915/funasr-deploy-kit/blob/main/docs/zh/deployment/deploy.md)
- [配置说明](https://github.com/332560915/funasr-deploy-kit/blob/main/docs/zh/deployment/configuration.md)
- [离线部署](https://github.com/332560915/funasr-deploy-kit/blob/main/docs/zh/deployment/offline-deploy.md)
- [常见问题](https://github.com/332560915/funasr-deploy-kit/blob/main/docs/zh/operations/troubleshooting.md)
