# PHOENIX!!!!!

![alt tag](http://sp7.fotolog.com/photo/23/10/44/cosmosaintseiya/1299851552402_f.jpg)


Based on this brilliant idea:

http://ariya.ofilabs.com/2014/12/docker-and-phoenix-how-to-make-your-continuous-integration-more-awesome.html

Phoenix build process:

    1)Checkout https://github.com/sloppylopez/phoenix-server

    2)cd phoenixserver

    3)sudo sh init.sh <GIT_USER> <GIT_PROJECT_NAME> <TARGET_EXEC> <DOCKER_CONTAINER_BASE_IMAGE>
      example: sudo sh init.sh sloppylopez nodeapi server.js phusion/baseimage:0.9.16


    INFO:init.sh will execute build.sh and when finished, init will execute run

