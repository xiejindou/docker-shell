#!/bin/bash

NGINX_HOME=$(cd "$(dirname "$0")";pwd)/data
image=nginx:stable-alpine

function init(){
    # docker nginx installation documentation
    # Install the configuration file in the nginx folder of the current directory

    name=nginx-temp
    docker run --name ${name} -d ${image}

    mkdir -p ${NGINX_HOME}/cert
    mkdir -p ${NGINX_HOME}/logs

    docker cp ${name}:/etc/nginx/nginx.conf ${NGINX_HOME}/nginx.conf
    docker cp ${name}:/etc/nginx/conf.d ${NGINX_HOME}
    docker cp ${name}:/usr/share/nginx/html ${NGINX_HOME}

    echo "Directory creation completed..."

    docker stop ${name}
    docker rm ${name}
    echo "Docker initialization nginx is completed!"
}

function start(){
    name=nginx
    if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
        docker stop ${name} && docker rm ${name}
    fi

    docker run --name ${name} \
    --net host \
    -v ${NGINX_HOME}/conf.d:/etc/nginx/conf.d \
    -v ${NGINX_HOME}/cert:/etc/nginx/cert \
    -v ${NGINX_HOME}/nginx.conf:/etc/nginx/nginx.conf \
    -v ${NGINX_HOME}/logs:/var/log/nginx \
    -v ${NGINX_HOME}/html:/usr/share/nginx/html \
    --restart=unless-stopped \
    -d  ${image}
}


if [ ! -e "./data/nginx.conf" ]; then
    init
fi

start

