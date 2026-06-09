# FunASR Deploy Kit Offline Package

This is the offline delivery package for `funasr-deploy-kit`. After extraction, you can verify, install, start, and test the service without accessing the source repository.

## Install

Install to `/data/funasr` by default:

```bash
bash install.sh
```

Install to `/opt/funasr`:

```bash
bash install.sh /opt
```

Skip confirmation:

```bash
bash install.sh /opt --yes
```

## Verify

```bash
cd /data/funasr
docker compose ps
curl http://127.0.0.1:18000/health
```

Swagger test page:

```text
http://127.0.0.1:18000/docs
```

For more details, see:

```text
funasr-deploy-kit/docs/en/deployment/offline-deploy.md
```

Hotword configuration:

```text
/data/funasr/runtime/config/hotwords.txt
/data/funasr/runtime/config/hotwords.txt.template
```

`hotwords.txt` is the runtime file and should contain only actual hotword data lines. `hotwords.txt.template` is a reference file and may contain comments.
