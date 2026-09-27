# ask-ai

Container image for [aichat](https://github.com/sigoden/aichat), a command line AI chat
client, pinned to a single `aichat` release and published to GitHub Container Registry.

The image contains nothing but Alpine, CA certificates and the `aichat` binary. It ships
no configuration, no credentials, no endpoints and no models — everything is supplied at
runtime, and the image runs as whatever user you pass with `docker run --user`.

## Usage

Pin the image to a released tag and mount your aichat configuration read-only:

```bash
docker run --rm -it \
  -v "${HOME}/.config/aichat:/cfg/aichat:ro" \
  -e XDG_CONFIG_HOME=/cfg \
  ghcr.io/bacluc-agent/ask-ai:0.0.1 \
  --model openai:gpt-4o --role '%shell%' -- "what is in the current directory?"
```

`XDG_CONFIG_HOME=/cfg` together with the `/cfg/aichat` mount is what aichat reads its
config from, so the read-only mount keeps the container from writing to your host config.

Available tags: `0.0.1` and `latest`. Renovate tracks the Alpine base image and the
`aichat` version plus its SHA-256 checksum, and opens (and automerges) an update PR for
both whenever a newer `aichat` release is at least 14 days old.

## Workflows

- `Autorelease` (`.github/workflows/auto-release.yaml`): `bump:patch`, `bump:minor` and
  `bump:major` are the user-facing signal for a Dockerfile/published-image change. Only
  dependency updates that change `Dockerfile` (the Alpine base image,
  `AICHAT_VERSION` or `AICHAT_SHA256`) carry a `bump:*` label. On a merged labelled pull
  request, the [pr-label-tag-action](https://github.com/projectsyn/pr-label-tag-action)
  creates the next `v*` tag and dispatches `Release`, which builds and publishes the image
  and creates the GitHub release. Pull requests changing only `.github/**` or `renovate.json`
  (including Renovate `github-actions` and `renovate-config` updates) get `dependency` only
  and never bump, tag, publish or release.
- `Release` (`.github/workflows/release.yaml`): triggered by a `v*` tag, builds the image
  for `linux/amd64` and publishes `ghcr.io/bacluc-agent/ask-ai:<version-without-v>` and
  `ghcr.io/bacluc-agent/ask-ai:latest`, then creates the GitHub release with a changelog
  built from the merged pull requests and their labels.
- `CI` (`.github/workflows/ci.yaml`): validates `renovate.json`, builds the image, runs
  `aichat --version`, and repeats that under an arbitrary numeric user id.
- Renovate ([`renovate.json`](renovate.json)) opens and automerges Alpine base-image and
  pinned `aichat` Dockerfile updates after the minimum release age of 14 days; workflow and
  configuration updates get dependency only and never release.

## License

[MIT](LICENSE)

This image is maintained by Bacluc for personal use only. No guarantees, support, or compatibility commitments are provided.
