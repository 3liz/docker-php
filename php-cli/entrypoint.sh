#!/bin/bash

set -e

CURRENT_USER_ID=$(id -u)

if [ "$CURRENT_USER_ID" == "0" ]; then
  echo "setup user id"
  if [ "$APP_GROUP_ID" != "" ]; then
     groupmod -g $APP_GROUP_ID groupphp
  fi

  if [ "$APP_USER_ID" != "" ]; then
     usermod -u $APP_USER_ID userphp
  fi

  chown userphp:groupphp /app
fi

for entry in $(ls /bin/entrypoint.d/)
do
  source $entry
done


if [ "$1" == "exec_userphp" ]; then
  shift
  cmd="$@"
  su userphp -c "$cmd"
  exit
fi

exec "$@"
