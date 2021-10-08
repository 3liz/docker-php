#!/bin/bash
export DISPLAY_ERRORS=on

echo "should show a warning below:"

docker run -i -e DISPLAY_ERRORS jelix/php-cli:7.4 php -r "echo foo;"


