#!/bin/bash
name=mysql8

docker stop ${name} && docker rm ${name}

data=$(cd "$(dirname "$0")"; pwd)/data

docker run --name ${name} \
--restart=unless-stopped \
-e MYSQL_ROOT_PASSWORD=your_password \
-v /etc/timezone:/etc/timezone:ro \
-v /etc/localtime:/etc/localtime:ro \
-v ${data}:/var/lib/mysql \
-p 3306:3306 \
-d mysql:8.0.25