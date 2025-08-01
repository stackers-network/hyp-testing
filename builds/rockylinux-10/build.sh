#!/bin/bash

set -ex

# Build the container image
docker build --platform=linux/amd64 -t rocky-10-fips .

# Build ISO from that container
docker run --platform=linux/amd64 --rm -ti \
-v "$PWD"/build:/tmp/auroraboot \
-v /var/run/docker.sock:/var/run/docker.sock \
quay.io/kairos/auroraboot:v0.7.0 \
--set container_image=docker://rocky-10-fips \
--set "disable_http_server=true" \
--set "disable_netboot=true" \
--set "state_dir=/tmp/auroraboot"