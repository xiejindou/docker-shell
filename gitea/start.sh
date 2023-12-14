#!/bin/bash

name=gitea
data=$(cd "$(dirname "$0")"; pwd)/data

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name ${name} \
--privileged=true \
-v ${data}:/data \
-p 3000:3000 \
-p 2222:22 \
--restart=unless-stopped \
-d gitea/gitea:latest