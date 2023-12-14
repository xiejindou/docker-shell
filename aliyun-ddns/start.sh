#!/bin/bash

name=aliyun-ddns

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name $name \
--restart=unless-stopped \
-e "AKID=xxxxx" \
-e "AKSCT=xxxx" \
-e "DOMAIN=your domain" \
-e "REDO=600" \
-d chenhw2/aliyun-ddns-cli

#dockerhub address: https://hub.docker.com/r/chenhw2/aliyun-ddns-cli