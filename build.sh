#!/usr/bin/env bash
#this is for exiting the sh when a non-zero code is returned by any operation
set -e

SOURCE_PATH=/source/$GIT_PROJECT_NAME
BUILD_PATH=$HOME/build
DESTINATION=node_modules #in case of a java project this would be the war file
INITIAL_NODE_VERSION=0.12
echo "BUILD_PATH " $BUILD_PATH

echo "Recreating build directory $BUILD_PATH"
rm -rf $BUILD_PATH && mkdir -p $BUILD_PATH
echo "Transferring the source: $SOURCE_PATH/$GIT_PROJECT_NAME -> $BUILD_PATH"
cd $BUILD_PATH && cp -rp $SOURCE_PATH . && cd $GIT_PROJECT_NAME

#put your build instructions here...
echo "♠ Building... This may take several minutes"

apt-get update -qq
apt-get install -y -qq curl git python build-essential

curl -sL https://deb.nodesource.com/setup_$INITIAL_NODE_VERSION | sudo bash -
apt-get install -y nodejs

npm install -g n
#. ~/.bashrc
n $NODE_VERSION
echo "########################################################################"
echo "Using NodeJS version : " && node -v
echo "########################################################################"
npm i
#consider running tests here
echo "Build finished"
#end put your build instructions here...

echo "Transferring build artifact..."
echo $DESTINATION $SOURCE_PATH/$DESTINATION
cp -r $DESTINATION $SOURCE_PATH/$DESTINATION

echo "All build tasks completed, have a nice day"