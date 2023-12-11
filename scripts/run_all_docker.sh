#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

echo "Create localnet"
docker network create petnet

echo "Starting Monitoring"

docker run -p 127.0.0.1:9090:9090 -itd --network=petnet --name prometheus amitbb16/petclinic-prometheus:v1
docker run -p 127.0.0.1:3000:3000 -itd --network=petnet --name grafana amitbb16/petclinic-grafana:v1
# docker run -p 127.0.0.1:9411:9411 -td openzipkin/zipkin:latest-s390x

echo "Monitoring Started"

echo "Running apps"

docker run -p 127.0.0.1:8888:8888 -d --network=petnet --name config-server amitbb16/petclinic-config-server:v1
echo "Waiting for config server to start"
sleep 20

docker run -p 127.0.0.1:8761:8761 -itd --network=petnet --name discovery-server amitbb16/petclinic-discovery-server:v1
echo "Waiting for discovery server to start"
sleep 20

docker run -p 127.0.0.1:8081:8081 -itd --network=petnet --name customers-service amitbb16/petclinic-customers-service:v1
docker run -p 127.0.0.1:8082:8082 -itd --network=petnet --name visits-service amitbb16/petclinic-visits-service:v1
docker run -p 127.0.0.1:8083:8083 -itd --network=petnet --name vets-service amitbb16/petclinic-vets-service:v1
docker run -p 127.0.0.1:8080:8080 -itd --network=petnet --name api-gateway amitbb16/petclinic-api-gateway:v1
docker run -p 127.0.0.1:9091:9091 -itd --network=petnet --name admin-serve amitbb16/petclinic-admin-server:v3
echo "Waiting for apps to start"
sleep 60