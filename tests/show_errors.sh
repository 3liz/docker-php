#!/bin/bash
export DISPLAY_ERRORS=on

echo "should show a warning below:"

docker run -i -e DISPLAY_ERRORS --rm  --name 3liz-php-cli 3liz/liz-php-cli:8.1 php -r "echo foo;"


