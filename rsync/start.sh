#!/bin/bash

name=rsync
# Where to store configuration
data=$(cd `dirname $0`;pwd)/data
# Where you need to sync
rsync_place=/anywhere
image=xiejindou/rsyncssh:alpine

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run --name ${name} \
-p 2222:22 \
-v ${data}/authorized_keys:/home/user/.ssh/authorized_keys \
-v ${rsync_place}:/mnt/xxxx \
-d ${image}

docker exec -it ${name} chmod 600 /home/user/.ssh/authorized_keys
docker exec -it ${name} chown user:user /home/user/.ssh/authorized_keys