#!/bin/bash

name=mongodb
data=$(cd "$(dirname "$0")"; pwd)/data

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name $name \
-v ${data}:/data/db \
--privileged=true \
-p 27017:27017 \
-e MONGO_INITDB_ROOT_USERNAME=root \
-e MONGO_INITDB_ROOT_PASSWORD=your_password \
-d mongo:4.2.23