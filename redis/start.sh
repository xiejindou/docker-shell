#!/bin/bash

name=redis
HOME=$(cd "$(dirname "$0")"; pwd)
image=redis:7.2.0-alpine

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name ${name} \
-p 6379:6379 \
--restart=unless-stopped \
--log-driver json-file \
--log-opt max-size=60m \
--log-opt max-file=20 \
-v ${HOME}/redis.conf:/etc/redis/redis.conf \
-v ${HOME}/data:/data \
-d ${image} redis-server /etc/redis/redis.conf \
--appendonly yes



# Notes: 
# - First download the corresponding redis.conf according to the redis version. from https://redis.io/docs/management/config/
# - --log-** These three configurations mean to store logs in json format. Each log can be up to 60m, and a total of 20 copies are stored.