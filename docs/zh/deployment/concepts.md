# 目录语义

本文说明工程目录、模板目录、运行目录和离线数据之间的职责边界。

## 工程目录

```text
components/        组件源码
deploy-template/   部署和离线包模板
scripts/           场景脚本
docs/              项目文档
```

工程目录用于构建镜像、生成运行目录、制作离线包和维护文档，不作为生产运行目录。

## 部署模板目录

`deploy-template/` 保存安装时需要复制的模板：

```text
deploy-template/
|-- docker-compose.yml
|-- compose.env.template
|-- README.md
|-- README.en.md
|-- config/
`-- offline-package/
```

部署后，`deploy-template/README.md` 会复制为运行目录中的 `README.md`，供部署后的用户查看常用命令和文档入口。

## 运行目录

默认运行目录：

```text
/data/funasr/
|-- docker-compose.yml
|-- .env
|-- README.md
|-- README.en.md
`-- runtime/
    |-- config/
    |-- logs/
    |-- models/
    `-- tmp/
```

服务启动后只依赖运行目录。工程目录可以作为维护资料保留，也可以在不需要脚本和源码时删除。

## 模板到运行文件

```text
deploy-template/docker-compose.yml            -> /data/funasr/docker-compose.yml
deploy-template/compose.env.template          -> /data/funasr/.env
deploy-template/README.md                     -> /data/funasr/README.md
deploy-template/config/http-api.env.template  -> /data/funasr/runtime/config/http-api.env
deploy-template/config/hotwords.txt.template  -> /data/funasr/runtime/config/hotwords.txt.template
```

热词运行文件由安装流程初始化为空文件：

```text
/data/funasr/runtime/config/hotwords.txt
```

`hotwords.txt` 只写真实热词数据行；`hotwords.txt.template` 是格式参考。
