#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    SED_COMMAND="sed -i ''"
else
    # Linux
    SED_COMMAND="sed -i"
fi

$SED_COMMAND "s/DOCKER_PROJECT_TITLE=sf_app_template_title/DOCKER_PROJECT_TITLE=sf_app_$(LC_CTYPE=C tr -dc a-z0-9 </dev/urandom | head -c 6 ; echo '')/g" ./.env.dist
$SED_COMMAND "s/DOCKER_NGINX_PORT=0/DOCKER_NGINX_PORT=$(shuf -i 47000-48000 -n 1)/g" ./.env.dist
$SED_COMMAND "s/DOCKER_POSTGRESQL_PORT=0/DOCKER_POSTGRESQL_PORT=$(shuf -i 47000-48000 -n 1)/g" ./.env.dist
$SED_COMMAND "s/DOCKER_LOCAL_NETWORK_IP=192.168.0.1/DOCKER_LOCAL_NETWORK_IP=192.168.$(shuf -i 200-255 -n 1).0/g" ./.env.dist
