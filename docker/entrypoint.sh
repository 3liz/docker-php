#!/bin/bash

set -e

CURRENT_USER_ID=$(id -u)

if [ "$CURRENT_USER_ID" == "0" ]; then

  GROUPID=$(getent group groupphp | cut -d: -f3)
  USERID=$(id -u userphp)

  if [ "$APP_GROUP_ID" != "" -a "$APP_GROUP_ID" != "$GROUPID" ]; then
     groupmod -g $APP_GROUP_ID groupphp
  fi
  if [ "$APP_USER_ID" != "" -a "$APP_USER_ID" != "$USERID" ]; then
     usermod -u $APP_USER_ID userphp
  fi

  chown userphp:groupphp /app

  if [ -z "$NO_HOME_CHOWN" ];  then
    chown -R userphp:groupphp /home/userphp
  fi

  if [ "$DISPLAY_ERRORS" == "on" ]; then
      sed -i "/^display_errors =/c\display_errors = On" /etc/php/${PHP_VERSION}/cli/php.ini;
  else
      sed -i "/^display_errors =/c\display_errors = Off" /etc/php/${PHP_VERSION}/cli/php.ini;
  fi
fi

for entry in $(ls /bin/entrypoint.d/)
do
  source /bin/entrypoint.d/$entry $@
done


if [ "$1" == "exec_userphp" ]; then
  shift
  cmd="$@"
  su userphp -c "$cmd"
  exit
fi

exec "$@"
