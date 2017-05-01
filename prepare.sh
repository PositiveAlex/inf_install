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
apt-get install -y docker-ce docker-compose
docker run hello-world

export DDOMAIN_NAME=$1
export MAIL_USER=$2
export MAIL_PASS=$3

mkdir -p ./docker-mailserver/config
touch ./docker-mailserver/config/postfix-accounts.cf
docker run --rm \
  -e MAIL_USER=$MAIL_USER \
  -e MAIL_PASS=$MAIL_PASS \
  -ti tvial/docker-mailserver:latest \
  /bin/sh -c 'echo "$MAIL_USER|$(doveadm pw -s SHA512-CRYPT -u $MAIL_USER -p $MAIL_PASS)"' > ./docker-mailserver/config/postfix-accounts.cf

docker run --rm \
  -v "$(pwd)/docker-mailserver/config":/tmp/docker-mailserver \
  -ti tvial/docker-mailserver:latest generate-dkim-config

export COMPOSE_FILE=./docker-mailserver/docker-compose.yml

docker-compose up -d mail

exit 0