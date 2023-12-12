#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

if (docker network ls | grep petnet | awk '{print $2}')
then
echo "petnet present"
docker network rm $(docker network ls | grep petnet | (awk '{print $1}'))
fi

echo "Create localnet"
docker network create --driver bridge petnet

echo "Running apps"

docker run -p 127.0.0.1:8888:8888 -d --network=petnet --name config-server amitbb16/petclinic-config-server:v1
echo "Waiting for config server to start"
sleep 20

docker run -p 127.0.0.1:8761:8761 -itd --network=petnet --name discovery-server amitbb16/petclinic-discovery-server:v6
echo "Waiting for discovery server to start"
sleep 20