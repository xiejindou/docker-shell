#!/bin/bash

name=firefox
data=$(cd `dirname $0`;pwd)/data

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name=$name \
-e TZ=Asia/Hong_Kong \
-e DISPLAY_WIDTH=1920 \
-e DISPLAY_HEIGHT=1080 \
-e KEEP_APP_RUNNING=1 \
-e ENABLE_CJK_FONT=1 \
-e VNC_PASSWORD=your_vnc_password \
-p 5800:5800 \
-v ${data}:/config:rw \
--security-opt seccomp=unconfined \
--shm-size 2048m \
--restart=unless-stopped \
-d jlesage/firefox