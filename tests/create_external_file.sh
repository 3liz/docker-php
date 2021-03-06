#!/bin/bash

export APP_USER_ID=${APP_USER_ID:-$(id -u)}
export APP_GROUP_ID=${APP_GROUP_ID:-$(id -g)}

docker run -i -e APP_GROUP_ID -e APP_USER_ID -v `pwd`/tmp:/app --name 3liz-php-cli --rm 3liz/liz-php-cli:8.1 exec_userphp touch /app/hello

echo "You should have a 'tmp/hello' file owned by you."

