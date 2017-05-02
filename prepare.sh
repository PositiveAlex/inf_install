#!/bin/bash

# Docker installation scrtip from the official doc at: 
# https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository

export PROJECT_PATH=$1
export DDOMAIN_NAME=$2
export MAIL_USER=$3
export MAIL_PASS=$4

rm -rf $PROJECT_PATH/docker-mailserver/config

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
apt-get install -y docker-ce docker-compose
docker run hello-world


mkdir -p $PROJECT_PATH/docker-mailserver/config
touch $PROJECT_PATH/docker-mailserver/config/postfix-accounts.cf
docker run --rm \
  -e MAIL_USER=$MAIL_USER \
  -e MAIL_PASS=$MAIL_PASS \
  -ti tvial/docker-mailserver:latest \
  /bin/sh -c 'echo "$MAIL_USER|$(doveadm pw -s SHA512-CRYPT -u $MAIL_USER -p $MAIL_PASS)"' > $PROJECT_PATH/docker-mailserver/config/postfix-accounts.cf

docker run --rm \
  -v "$PROJECT_PATH/docker-mailserver/config":/tmp/docker-mailserver \
  -ti tvial/docker-mailserver:latest generate-dkim-config

export COMPOSE_FILE=$PROJECT_PATH/docker-mailserver/docker-compose.yml

docker-compose up -d mail

exit 0