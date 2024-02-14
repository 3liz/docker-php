#!/bin/bash

echo "Go to http://localhost:9658"
export APP_USER_ID=${APP_USER_ID:-$(id -u)}
export APP_GROUP_ID=${APP_GROUP_ID:-$(id -g)}
export PHP_VERSION=${PHP_VERSION:=8.3}

(

cd app/
docker-compose -p docker-php-tests build
docker-compose -p docker-php-tests up

)
