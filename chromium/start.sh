#!/bin/bash

name=chromium
data=$(cd "$(dirname "$0")";pwd)/data
image=linuxserver/chromium:latest

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
    docker stop ${name} && docker rm ${name}
fi

docker run -d \
--name=${name} \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Etc/UTC \
-e CUSTOM_USER=xxxxx \
-e PASSWORD=xxxxx \
-e DOCKER_MODS=linuxserver/mods:universal-package-install \
-e INSTALL_PACKAGES=fonts-noto-cjk \
-e LC_ALL=zh_CN.UTF-8 \
-p 80:3000 \
-v ${data}/config:/config \
--shm-size="1gb" \
--restart unless-stopped \
${image}