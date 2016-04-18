#!/usr/bin/env bash
#this is for exiting the sh when a non-zero code is returned by any operation
set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ] || [ -z "$7" ]
then
   echo "usage: sudo sh init.sh <GIT_USER> <GIT_PROJECT_NAME> <TARGET_EXEC> <DOCKER_CONTAINER_BASE_IMAGE> <TIMEOUT_FOR_BUILD>"
   echo "example: sudo sh init.sh sloppylopez nodeapi server.js ubuntu:14.04 stash 0.12.2 30m"
   exit
fi

GIT_USER=$1
GIT_PROJECT_NAME=$2
TARGET_EXEC=$3
CONTAINER=$4
REPO=$5
NODE_VERSION=$6
TIMEOUT_FOR_BUILD=$7
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
SOURCE_PATH=`dirname $SCRIPT_PATH`

echo "Container to be used: $CONTAINER."
docker pull $CONTAINER
#TODO comment this line befre commit
rm -rf $GIT_PROJECT_NAME
#TODO Uncomment me for non-local use
#apt-get install git && \
if [ $REPO = "git" ]
then
    git clone https://github.com/$GIT_USER/$GIT_PROJECT_NAME.git
else
    git clone https://$GIT_USER@stash.eden.klm.com/scm/c3s/$GIT_PROJECT_NAME.git
fi

#timeout for the build script, to avoid zombies in case of uncontrolled failure
TIMEOUT=$TIMEOUT_FOR_BUILD
echo "Triggering the build (with ${TIMEOUT} timeout) to avoid Zombies..."
timeout --signal=SIGKILL ${TIMEOUT} \
  docker run -v $SCRIPT_PATH:/source \
  -e "GIT_PROJECT_NAME=$GIT_PROJECT_NAME" \
  -e "NODE_VERSION=$NODE_VERSION" \
  --rm \
  $CONTAINER sh -c "/source/build.sh"

echo "Running $GIT_PROJECT_NAME"

sh run.sh $GIT_PROJECT_NAME

echo "All init tasks completed"