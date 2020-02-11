#!/bin/bash

set -e
set -u

DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:=defimage}



if [ -v TZ ]; then
  echo timezone set to $TZ
else
  export TZ='America/Boise'
  echo set timezone to $TZ
fi

IMAGENAME=${DOCKER_IMAGE_NAME}:$(date +%s)
echo using image name ${IMAGENAME}

WORKDIR=$(cd .. && pwd -P)
echo WORKDIR is $WORKDIR

uid=$(id -u)
gid=$(id -g)
username=$(id -nu)
groupname=$(id -ng)

cp scripts/requirements.txt docker

BUILD_OPTS="--build-arg uid=$uid \
  --build-arg gid=$gid \
  --build-arg username=$username \
  --build-arg groupname=$groupname"



#echo env vars:
#set

if [ -z ${HTTP_PROXY-} ] && [ ! -z ${http_proxy-} ]; then
  echo populating HTTP_PROXY from http_proxy ${http_proxy}
  HTTP_PROXY=${http_proxy}
fi


if [ -z ${HTTPS_PROXY-} ] && [ ! -z ${https_proxy-} ]; then
  echo populating HTTPS_PROXY from https_proxy ${https_proxy}
  HTTPS_PROXY=$https_proxy
fi

if [ ! -z ${HTTP_PROXY-} ]; then
  echo using HTTP_PROXY ${HTTP_PROXY}
  BUILD_OPTS="${BUILD_OPTS} --build-arg HTTP_PROXY=${HTTP_PROXY}"
fi

if [ ! -z ${HTTPS_PROXY-} ]; then
  echo using HTTPS_PROXY ${HTTPS_PROXY}
  BUILD_OPTS="$BUILD_OPTS --build-arg HTTPS_PROXY=${HTTPS_PROXY}"
fi

echo BUILD_OPTS:
echo $BUILD_OPTS

pushd docker && docker build . --file Dockerfile --tag ${IMAGENAME} \
  $BUILD_OPTS
popd

echo image build complete

if [ -t 1 ] ; then
  echo in a terminal
  RUN_OPTS=-it
else
  echo not in a terminal
  RUN_OPTS=-i
fi

echo running container

docker run --rm \
  -v $WORKDIR:$WORKDIR \
  -w "$WORKDIR" \
  -e "HOME=$WORKDIR" \
  -e "TZ=$TZ" \
  $RUN_OPTS \
  ${IMAGENAME} \
  $*

echo run complete
