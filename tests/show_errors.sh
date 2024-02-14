#!/bin/bash
export DISPLAY_ERRORS=on
PHP_VERSION=${PHP_VERSION:=8.3}

echo "v=" $PHP_VERSION
exit 0

echo "should show a warning below:"

docker run -i -e DISPLAY_ERRORS --rm  --name 3liz-php-cli 3liz/liz-php-cli:$PHP_VERSION php -r "echo foo;"


