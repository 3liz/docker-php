#!/bin/bash

export APP_USER_ID=${APP_USER_ID:-$(id -u)}
export APP_GROUP_ID=${APP_GROUP_ID:-$(id -g)}

docker run -i -e APP_GROUP_ID -e APP_USER_ID -v `pwd`/tests/tmp:/app jelix/php-cli:7.4 exec_userphp touch /app/hello


