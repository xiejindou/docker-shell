#!/bin/bash

name=webdav-client
# The local path you will mount.
data=/xxxx

if docker ps -a --format '{{.Names}}' | grep -q ${name}; then
     docker stop ${name} && docker rm ${name}
fi

docker run -d \
  --name=${name} \
  --env WEBDRIVE_USERNAME=xxxxx \
  --env WEBDRIVE_PASSWORD=xxxxxxx \
  --env WEBDRIVE_URL=http://xxxxx \
  --env DAVFS2_ASK_AUTH=0 \
  --device=/dev/fuse \
  --cap-add=SYS_ADMIN \
  --security-opt="apparmor=unconfined" \
  --volume=${data}:/mnt/webdrive:rshared \
  --restart=unless-stopped \
  efrecon/webdav-client

# Note: If it prompts that "xxx is mounted on / but it is not a shared mount", execute in the terminal: "mount --make-rshared /"