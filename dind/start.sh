#!/bin/bash

DIND_ROOT=$(cd "$(dirname "$0")";pwd)/data
DIND_IMAGE=xiejindou/debian:bookworm-dindsys
DIND_NAME=dind

init(){
    name=dind-temp
    docker run --name ${name} -d ${DIND_IMAGE}
    docker cp ${name}:/ ${DIND_ROOT}/
    echo "Docker data initialization is complete..."
    docker stop ${name}
    docker rm ${name}
}

start(){
    if docker ps -a --format '{{.Names}}' | grep -q ${DIND_NAME}; then
        docker stop ${DIND_NAME} && docker rm ${DIND_NAME}
    fi

    docker run --privileged --name ${DIND_NAME} \
    -v ${DIND_ROOT}/.dockerenv:/.dockerenv \
    -v ${DIND_ROOT}/boot:/boot \
    -v ${DIND_ROOT}/data:/data \
    -v ${DIND_ROOT}/etc:/etc \
    -v ${DIND_ROOT}/home:/home \
    -v ${DIND_ROOT}/lib:/lib \
    -v ${DIND_ROOT}/lib64:/lib64 \
    -v ${DIND_ROOT}/media:/media \
    -v ${DIND_ROOT}/mnt:/mnt \
    -v ${DIND_ROOT}/opt:/opt \
    -v ${DIND_ROOT}/root:/root \
    -v ${DIND_ROOT}/sbin:/sbin \
    -v ${DIND_ROOT}/srv:/srv \
    -v ${DIND_ROOT}/tmp:/tmp \
    -v ${DIND_ROOT}/usr:/usr \
    -v ${DIND_ROOT}/var:/var \
    -v ${DIND_ROOT}/var/lib/docker:/var/lib/docker \
    -v /etc/localtime:/etc/localtime:ro \
    --net host \
    -d ${DIND_IMAGE}
    echo -e "${DIND_NAME} start completed. ✅ "
}

service_start(){
    str="printf '#!/bin/sh -e\n\n\nexit 0' > /etc/rc.local && chmod +x /etc/rc.local"
    str="$str && systemctl enable rc-local && systemctl start rc-local"
    str="$str && systemctl enable docker && systemctl start docker"
    docker exec ${DIND_NAME} /bin/bash -c "$str"
    echo -e "rc-local and docker start completed. ✅ "
}


if [ ! -e "./data/.dockerenv" ]; then
    init
fi

start && sleep 2 && service_start

#Then you can add alias `docker exec -it dind /bin/bash` on your ~/.bashrc to enter dind.
#It's very important about that: -v ${DIND_ROOT}/var/lib/docker:/var/lib/docker,This directory is where the docker data is stored. If you don't mount it separately, the docker image will disappear when you re-execute this script again.
