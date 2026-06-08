# Scripts

This directory only keeps shell scripts that can run on Linux/macOS. Production offline deployment targets are treated as Linux servers.

Scripts locate the repository root from their own file path, so they do not depend on the current working directory.

## Script List

```text
build.sh             Build images defined in Compose
package-offline.sh   Package offline images and runtime data
load-offline.sh      Import and start services on an offline server
```

## Quick Usage

```bash
bash scripts/build.sh
bash scripts/package-offline.sh
bash scripts/load-offline.sh /data
```

## Related Documentation

- [Build Images](../docs/en/deployment/build.md)
- [Offline Package](../docs/en/deployment/offline-package.md)
- [Offline Deployment](../docs/en/deployment/offline-deploy.md)
