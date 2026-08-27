# ZeroNetX Docker Image

Alternative (and improved) Dockerfile + entrypoint script for ZeroNetX
([Original](https://github.com/ZeroNetX/ZeroNet/blob/py3-latest/Dockerfile))

## What's new?

- Tor is enforced (`--tor always`) and runs as its own service
- ZeroNetX runs on an `internal` network with no gateway, so it can only reach Tor (killswitch)
- Moved startup directory to `/zeronet`
- Moved data directory to `/data`
- Config file `zeronet.conf` is moved to `/data` (to persist between container restarts)
- Supports passing custom ZeroNetX arguments

## How to start?

```shell
curl -O https://raw.githubusercontent.com/dreamscached/zeronetx-docker/master/docker-compose.yml
docker compose up -d
```

The web interface is then available at <http://127.0.0.1:43110>.

## Custom arguments

Anything passed to the `zeronetx` container is appended to the defaults:

```yaml
services:
  zeronetx:
    command: ["--verbose"]
```

The full list is in
[ZeroNetX's `Config.py`](https://github.com/ZeroNetX/ZeroNet/blob/py3-latest/src/Config.py).
