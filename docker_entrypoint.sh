#!/bin/sh

# Start Tor in background
tor &

# Use venv and start ZeroNetX
# shellcheck disable=SC1091
. venv/bin/activate
python3 zeronet.py                   \
    --ui_ip 0.0.0.0                  \
    --fileserver_port 26117          \
    --config_file /data/zeronet.conf \
    --data_dir /data
