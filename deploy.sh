#!/bin/bash

set -e
set -x

docker compose down


if [[ "$1" == "dev" ]]; then
  DOCKERFILE_PATH=./local.Dockerfile docker compose build
else
  docker compose build 
fi

LOGGING_DRIVER=journald docker compose up --detach

