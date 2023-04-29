#!/usr/bin/env bash

HOST_DIR=/opt/bitwarden/bw-data
# HOST_DIR=/tmp/bw-data
CONTAINER_DIR=/data
export HOST_PORT=8080
export CONTAINER_PORT=8080

IMAGE_NAME_TAG=vaultwarden/server:latest

# Using sccomp=unconfined to overcome the following issue:
#   https://github.com/dani-garcia/vaultwarden/issues/2497#issuecomment-1137566303

docker run --rm --name bitwarden \
  -e ROCKET_PORT="$CONTAINER_PORT" \
  --volume $HOST_DIR:$CONTAINER_DIR \
  --user $(id -u):$(id -g) \
  -p 127.0.0.1:$HOST_PORT:$CONTAINER_PORT \
  -p 127.0.0.1:3012:3012 \
  --security-opt seccomp=unconfined \
  $IMAGE_NAME_TAG

# docker compose up
