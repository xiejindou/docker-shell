#!/bin/bash

# zerotier network id
network_id=xxxxxx
name=zerotier
data=$(cd `dirname $0`;pwd)/data

if [ ! -d "data/networks.d" ]; then
    mkdir -p data/networks.d
fi

if [ ! -f "data/networks.d/${network_id}.conf" ]; then
    touch data/networks.d/${network_id}.conf
fi

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run -d \
--restart unless-stopped \
--name ${name} --device=/dev/net/tun \
--net=host \
--cap-add=NET_ADMIN \
--cap-add=SYS_ADMIN \
-v ${data}:/var/lib/zerotier-one \
zyclonite/zerotier