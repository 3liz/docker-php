#!/bin/bash
PHP_VERSION=${PHP_VERSION:=8.3}
docker run -i  --name 3liz-php-cli --rm 3liz/liz-php-cli:$PHP_VERSION php --version

