#!/bin/bash


if [ "$1" == "/usr/sbin/php-fpm" ]; then
  echo "It launch PHP-FPM !!! "
else
  echo "command is not php-fpm: $1 "
fi

