#!/bin/bash

name=rsync
# Where to store configuration
data=$(cd `dirname $0`;pwd)/data
# Where you need to sync
rsync_place=/anywhere
mount_place=/mnt/xxxx
image=xiejindou/rsyncssh:alpine
port=2222


if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name ${name} \
-p ${port}:22 \
-v ${data}/authorized_keys:/home/user/.ssh/authorized_keys \
-v ${rsync_place}:${mount_place} \
-d ${image}

docker exec -it ${name} chmod 600 /home/user/.ssh/authorized_keys
docker exec -it ${name} chown user:user /home/user/.ssh/authorized_keys
docker exec -it ${name} chown user:user ${mount_place}