# ask-ai

A minimal Docker image for [aichat](https://github.com/sigoden/aichat) — an AI chat CLI.

## Usage

```bash
docker run --rm -it \
  -v "${HOME}/.config/aichat:/cfg/aichat:ro" \
  -e XDG_CONFIG_HOME=/cfg \
  ghcr.io/bacluc/ask-ai:0.30.0
```

## Workflows

- **Release**: triggered by `v*` tags, builds and pushes `ghcr.io/bacluc/ask-ai:<version>` and `:latest`.
- **Renovate**: updates Alpine base image, aichat version, and SHA-256 checksum automatically.

This repository is created and maintained by BacLuc. It uses automated dependency updates via Renovate and automated releases via GitHub Actions. This image is provided as-is without warranty; verify all downloaded artifacts independently.
