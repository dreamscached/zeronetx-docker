# ZeroNetX Docker Image

Alternative (and improved) Dockerfile + entrypoint script for ZeroNetX
([Original](https://github.com/ZeroNetX/ZeroNet/blob/py3-latest/Dockerfile))

## What's new?

- Tor is enabled by default
- Moved startup directory to `/zeronet`
- Moved data directory to `/data`
- Config file `zeronet.conf` is moved to `/data` (to persist between container restarts)

## How to start?

Run these commands in your termina:

```shell
docker volume create zeronetx-data
docker run -d --rm --name zeronetx -p 127.0.0.1:43110:43110 -v zeronetx-data:/data ghcr.io/dreamscached/zeronetx-docker:latest
```
