# FunASR Deploy Kit 离线包

这是 `funasr-deploy-kit` 的离线交付包。解压后无需访问源码仓库即可完成校验、安装、启动和验证。

## 安装

默认安装到 `/data/funasr`：

```bash
bash install.sh
```

安装到 `/opt/funasr`：

```bash
bash install.sh /opt
```

自动确认安装：

```bash
bash install.sh /opt --yes
```

## 验证

```bash
cd /data/funasr
docker compose ps
curl http://127.0.0.1:18000/health
```

Swagger 测试地址：

```text
http://127.0.0.1:18000/docs
```

更多说明见：

```text
funasr-deploy-kit/docs/zh/deployment/offline-deploy.md
```

热词配置：

```text
/data/funasr/runtime/config/hotwords.txt
/data/funasr/runtime/config/hotwords.txt.template
```

`hotwords.txt` 是运行文件，只写真实热词数据行；`hotwords.txt.template` 是格式参考，可以包含注释。
