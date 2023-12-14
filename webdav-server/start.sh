#!/bin/bash
# start a webdav server

name=webdav-server
docker stop ${name} && docker rm ${name}

data="anywhere you want to share"

docker run --name ${name} \
-p 8080:8080 \
-e WEBDAV_USERNAME=your_user_name \
-e WEBDAV_PASSWORD=your_password \
-e UID=$UID \
-v ${data}:/media \
--restart=unless-stopped \
-d ionelmc/webdav