# Scripts

This directory only keeps shell scripts usable on Linux/macOS. Production offline deployment targets are treated as Linux servers.

Scripts locate the repository root from their own path, so they do not depend on the current working directory.

## Scenario Scripts

```text
quick-start.sh       First run: build images, create runtime directory, start services, print verification commands
deploy-online.sh     Online deployment: create an independent runtime directory, optionally build and start
package-offline.sh   Create an offline delivery package in an online environment
install-offline.sh   Offline install entrypoint, usually called by the outer install.sh in the offline package
update.sh            Update running services by change type
lib/                 Internal helpers, not a user entrypoint
```

## Progressive Usage

First run:

```bash
bash scripts/quick-start.sh
```

Online deployment:

```bash
bash scripts/deploy-online.sh /data/funasr
```

Create offline package:

```bash
bash scripts/package-offline.sh
```

Install after extracting the offline package:

```bash
bash install.sh
bash install.sh /opt
```

Update HTTP API:

```bash
bash scripts/update.sh http-api /data/funasr
```

## Related Documentation

- [Getting Started](../docs/en/usage/getting-started.md)
- [Online Deployment](../docs/en/deployment/deploy.md)
- [Offline Packaging](../docs/en/deployment/offline-package.md)
- [Offline Deployment](../docs/en/deployment/offline-deploy.md)
- [Update and Maintenance](../docs/en/operations/update.md)
