#!/bin/bash

IP_ADDR="$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)"

echo "Starting server on $IP_ADDR ..."
cd /root/src
bun install
bun run --watch index.ts
