#!/usr/bin/env bash

set -E

CONT_NAME="workbench"

## Get the working path of the script.
PWD="$(pwd)/$(dirname $0)"

docker stop $CONT_NAME

docker rm $CONT_NAME

## Build the docker image.
docker build -t workbench:latest $PWD

## Run the docker image in a container.
docker run -it --init \
  --hostname=$CONT_NAME \
  --name $CONT_NAME \
  -p 3300:3300 \
  -p 5432:5432 \
  -v "$PWD/data:/data:rw" \
  -v "$PWD/src:/root/src:rw" \
  workbench:latest $@
