#!/usr/bin/env bash
#this is for exiting the sh when a non-zero code is returned by any operation
set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]
then
   echo "usage: sudo sh init.sh <GIT_USER> <GIT_PROJECT_NAME> <TARGET_EXEC> <DOCKER_CONTAINER_BASE_IMAGE>"
   exit
fi

GIT_USER=$1
GIT_PROJECT_NAME=$2
TARGET_EXEC=$3
CONTAINER=$4
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
SOURCE_PATH=`dirname $SCRIPT_PATH`

echo "Container to be used: $CONTAINER."
docker pull $CONTAINER
rm -rf $GIT_PROJECT_NAME
#apt-get install git && \
git clone https://github.com/$GIT_USER/$GIT_PROJECT_NAME.git

#timeout for the build script, to avoid zombies in case of uncontrolled failure
TIMEOUT=5m
echo "Triggering the build (with ${TIMEOUT} timeout)..."
timeout --signal=SIGKILL ${TIMEOUT} \
  docker run -v $SCRIPT_PATH:/source \
  -e "GIT_PROJECT_NAME=$GIT_PROJECT_NAME" \
  $CONTAINER sh -c "/source/build.sh"

echo "Running $GIT_PROJECT_NAME"

sh run.sh $GIT_PROJECT_NAME

echo "All init tasks completed"