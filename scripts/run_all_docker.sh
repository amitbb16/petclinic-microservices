#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

echo "Starting Monitoring"

docker run -p 127.0.0.1:9090:9090 -td amitbb16/petclinic-prometheus:v1
docker run -p 127.0.0.1:3000:3000 -td amitbb16/petclinic-grafana:v1
docker run -p 127.0.0.1:9411:9411 -td openzipkin/zipkin:latest-s390x

echo "Monitoring Started"

echo "Running apps"

docker run -p 127.0.0.1:8888:8888 -td amitbb16/petclinic-config-server:v1
echo "Waiting for config server to start"
sleep 20

docker run -p 127.0.0.1:8761:8761 -td amitbb16/petclinic-discovery-server:v1
echo "Waiting for discovery server to start"
sleep 20

docker run -p 127.0.0.1:8081:8081 -td amitbb16/petclinic-customers-service:v1
docker run -p 127.0.0.1:8082:8082 -td amitbb16/petclinic-visits-service:v1
docker run -p 127.0.0.1:8083:8083 -td amitbb16/petclinic-vets-service:v1
docker run -p 127.0.0.1:8080:8080 -td amitbb16/petclinic-api-gateway:v1
docker run -p 127.0.0.1:9091:9091 -td amitbb16/petclinic-admin-server:v3
echo "Waiting for apps to start"
sleep 60