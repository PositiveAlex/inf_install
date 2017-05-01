#!/bin/bash

# Docker installation scrtip from the official doc at: 
# https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository

apt-get install -y python \
                   python-pip \
                   apt-transport-https \
                   ca-certificates \
                   curl \
                   software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88

# for amd64

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install docker-ce
docker run hello-world
