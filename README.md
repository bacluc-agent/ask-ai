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

- `Autorelease` (`.github/workflows/auto-release.yaml`): on every merge of a pull request
  labelled `bump:patch`, `bump:minor` or `bump:major`, the
  [pr-label-tag-action](https://github.com/projectsyn/pr-label-tag-action) creates the next
  `v*` tag and dispatches `Release`.
- `Release` (`.github/workflows/release.yaml`): triggered by a `v*` tag, builds the image
  for `linux/amd64` and publishes `ghcr.io/bacluc-agent/ask-ai:<version-without-v>` and
  `ghcr.io/bacluc-agent/ask-ai:latest`, then creates the GitHub release with a changelog
  built from the merged pull requests and their labels.
- `CI` (`.github/workflows/ci.yaml`): validates `renovate.json`, builds the image, runs
  `aichat --version`, and repeats that under an arbitrary numeric user id.
- Renovate ([`renovate.json`](renovate.json)) keeps the base image and the pinned `aichat`
  release current.

## License

[MIT](LICENSE)

This image is maintained by Bacluc for personal use only. No guarantees, support, or compatibility commitments are provided.
