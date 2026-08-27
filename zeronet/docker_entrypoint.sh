#!/bin/sh
# shellcheck disable=SC1091
. venv/bin/activate
# arguments given to the container are added after the defaults
exec python3 zeronet.py              \
    --ui_ip 0.0.0.0                  \
    --fileserver_port 26117          \
    --tor_hs_port 26117              \
    --config_file /data/zeronet.conf \
    --data_dir /data                 \
    --tor_controller tor:9051        \
    --tor_proxy tor:9050             \
    --tor always                     \
    "$@"
