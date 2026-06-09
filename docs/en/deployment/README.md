# Deployment

This directory is for implementation and delivery work. It is organized progressively: understand directories, build images, deploy online, then migrate offline.

## Online Environment

1. [Directory Concepts](concepts.md): distinguish source directories, deployment templates, and the final runtime directory.
2. [Image Build Notes](build.md): understand which scenarios build images, how to skip builds, and where image names come from.
3. [Online Deployment](deploy.md): create an independent runtime directory on the target machine and start services.
4. [Configuration](configuration.md): change ports, models, mounts, HTTP API parameters, and hotword files.

## Offline Environment

1. [Offline Packaging](offline-package.md): create an offline package with images, runtime data, and project reference files in an online environment.
2. [Offline Deployment](offline-deploy.md): import images, restore runtime data, and start services without network access.

## Back

- [English Documentation Home](../index.md)
