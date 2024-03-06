#!/bin/bash

# Ensure that proper binary exists.
if [ -z "$(which bitcoind)" ]; then
  echo "Unable to find bitcoin binary!" && exit 1
fi

# Ensure that data directory exists for bitcoin.
if [ ! -d "$DATA/bitcoin" ]; then
  mkdir -p $DATA/bitcoin
fi

bitcoind -regtest -daemon \
  -conf="/config/bitcoin.conf" \
  -datadir="$DATA/bitcoin"
