#!/bin/bash


if [ "$1" == "/usr/bin/supervisord" ]; then
  echo "It launch PHP-FPM and Nginx !!! "
else
  echo "command is not php-fpm: $1 "
fi

