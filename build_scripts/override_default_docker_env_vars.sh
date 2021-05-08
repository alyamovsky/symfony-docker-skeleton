#!/bin/bash

sed -i "s/DOCKER_PROJECT_TITLE=sf5_app_template_title/DOCKER_PROJECT_TITLE=sf5_app_$(tr -dc a-z0-9 </dev/urandom | head -c 6 ; echo '')/g" ./.env.dist
sed -i "s/DOCKER_NGINX_PORT=0/DOCKER_NGINX_PORT=$(shuf -i 47000-48000 -n 1)/g" ./.env.dist
sed -i "s/DOCKER_POSTGRESQL_PORT=0/DOCKER_POSTGRESQL_PORT=$(shuf -i 47000-48000 -n 1)/g" ./.env.dist
sed -i "s/DOCKER_LOCAL_NETWORK_IP=192.168.0.1/DOCKER_LOCAL_NETWORK_IP=192.168.$(shuf -i 200-255 -n 1).1/g" ./.env.dist
