#!/bin/bash

name=redis
HOME=$(cd "$(dirname "$0")"; pwd)
image=redis

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name ${name} \
-p 6379:6379 \
-v ${HOME}/data:/data \
--log-driver json-file \
--log-opt max-size=60m \
--log-opt max-file=20 \
--restart=unless-stopped \
-d ${image} redis-server --requirepass 123456 \
--appendonly yes