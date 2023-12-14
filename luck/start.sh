#!/bin/bash

name=lucky
data=$(cd "$(dirname "$0")"; pwd)/data

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name ${name} \
--net=host  \
--privileged=true \
--restart=unless-stopped \
-v ${data}/luckyconf:/goodluck \
-d gdy666/lucky