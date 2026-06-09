# Scripts

This directory only keeps shell scripts that can run on Linux/macOS. Production offline deployment targets are treated as Linux servers.

Scripts locate the repository root from their own file path, so they do not depend on the current working directory.

## Script List

```text
build.sh             Build images defined in Compose
package-offline.sh   Create a complete offline delivery package
load-offline.sh      Import images from offline data and start services
```

## Quick Usage

```bash
bash scripts/build.sh
bash scripts/package-offline.sh
bash scripts/load-offline.sh ../offline-data /data
```

After extracting the offline delivery package, use the outer install entrypoint:

```bash
bash install.sh
bash install.sh /opt
```

## Related Documentation

- [Build Images](../docs/en/deployment/build.md)
- [Offline Package](../docs/en/deployment/offline-package.md)
- [Offline Deployment](../docs/en/deployment/offline-deploy.md)
