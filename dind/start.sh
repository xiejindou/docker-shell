#!/bin/bash

DIND_ROOT=$(cd "$(dirname "$0")";pwd)/data
DIND_IMAGE=xiejindou/dind:debian-bookworm
DIND_NAME=dind

function init(){
    name=dind-temp
    docker run --name ${name} -d ${DIND_IMAGE}
    docker cp ${name}:/ ${DIND_ROOT}/
    echo "Docker data initialization is complete..."
    docker stop ${name}
    docker rm ${name}
}

function start(){
    if docker ps -a --format '{{.Names}}' | grep -q ${DIND_NAME}; then
        docker stop ${DIND_NAME} && docker rm ${DIND_NAME}
    fi

    docker run --privileged --name ${DIND_NAME} \
    -v ${DIND_ROOT}/.dockerenv:/.dockerenv \
    -v ${DIND_ROOT}/boot:/boot \
    -v ${DIND_ROOT}/data:/data \
    -v ${DIND_ROOT}/etc:/etc \
    -v ${DIND_ROOT}/home:/home \
    -v ${DIND_ROOT}/media:/media \
    -v ${DIND_ROOT}/mnt:/mnt \
    -v ${DIND_ROOT}/opt:/opt \
    -v ${DIND_ROOT}/root:/root \
    -v ${DIND_ROOT}/srv:/srv \
    -v ${DIND_ROOT}/tmp:/tmp \
    -v ${DIND_ROOT}/usr:/usr \
    -v ${DIND_ROOT}/var:/var \
    -v /etc/localtime:/etc/localtime:ro \
    --net host \
    -d ${DIND_IMAGE}

    echo -e "${DIND_NAME}启动完毕 ✅ "
}


if [ ! -e "./data/.dockerenv" ]; then
    init
fi

start

#Then you can add alias `docker exec -it dind /bin/bash` on your ~/.bashrc to enter dind.
