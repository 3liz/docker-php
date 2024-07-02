#!/bin/bash

echo "Go to http://localhost:9659"
export APP_USER_ID=${APP_USER_ID:-$(id -u)}
export APP_GROUP_ID=${APP_GROUP_ID:-$(id -g)}
export PHP_VERSION=${PHP_VERSION:=8.3}

(
cd app2/
docker compose -p docker-php-web-tests build
docker compose -p docker-php-web-tests up
)
