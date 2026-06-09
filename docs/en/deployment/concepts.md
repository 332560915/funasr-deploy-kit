# Directory Concepts

This document explains the responsibility boundaries between the project directory, template directory, runtime directory, and offline data.

## Project Directory

```text
components/        Component source code
deploy-template/   Deployment and offline package templates
scripts/           Scenario scripts
docs/              Project documentation
```

The project directory is used to build images, create runtime directories, build offline packages, and maintain documentation. It is not the production runtime directory.

## Deployment Template Directory

`deploy-template/` stores templates copied during installation:

```text
deploy-template/
|-- docker-compose.yml
|-- compose.env.template
|-- README.md
|-- README.en.md
|-- config/
`-- offline-package/
```

After deployment, `deploy-template/README.md` is copied as `README.md` in the runtime directory for common commands and documentation links.

## Runtime Directory

Default runtime directory:

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

After startup, services depend only on the runtime directory. The project directory can be kept for maintenance or removed if scripts and source code are no longer needed.

## Template to Runtime Files

```text
deploy-template/docker-compose.yml            -> /data/funasr/docker-compose.yml
deploy-template/compose.env.template          -> /data/funasr/.env
deploy-template/README.md                     -> /data/funasr/README.md
deploy-template/config/http-api.env.template  -> /data/funasr/runtime/config/http-api.env
deploy-template/config/hotwords.txt.template  -> /data/funasr/runtime/config/hotwords.txt.template
```

The runtime hotword file is initialized as an empty file:

```text
/data/funasr/runtime/config/hotwords.txt
```

`hotwords.txt` should contain only real hotword data lines. `hotwords.txt.template` is a format reference.
