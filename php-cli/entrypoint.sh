#!/bin/bash

CURRENT_USER_ID=$(id -u)

if [ "$CURRENT_USER_ID" == "0" ]; then

  if [ "$APP_GROUP_NAME" != "groupphp" ]; then
    egrep -i "^groupphp:" /etc/group;
    if [ $? -eq 0 ]; then
       groupmod -n $APP_GROUP_NAME groupphp
    fi
  fi

  if [ "$APP_USER_NAME" != "userphp" ]; then
    egrep -i "^userphp:" /etc/passwd;
    if [ $? -eq 0 ]; then
       usermod -l $APP_USER_NAME userphp
    fi
  fi

  if [ "$APP_GROUP_ID" != "" ]; then
     groupmod -g $APP_GROUP_ID $APP_GROUP_NAME
  fi

  if [ "$APP_USER_ID" != "" ]; then
     usermod -u $APP_USER_ID $APP_USER_NAME
  fi

  chown $APP_USER_NAME:$APP_GROUP_NAME /app
fi

if [ "$DISPLAY_ERRORS" == "on" ]; then
    sed -i "/^display_errors =/c\display_errors = On" /etc/php/${PHP_VERSION}/cli/php.ini; \
else
    sed -i "/^display_errors =/c\display_errors = Off" /etc/php/${PHP_VERSION}/cli/php.ini; \
fi

set -e
for entry in $(ls /bin/entrypoint.d/)
do
  source /bin/entrypoint.d/$entry
done


if [ "$1" == "exec_userphp" ]; then
  shift
  cmd="$@"
  su $APP_USER_NAME -c "$cmd"
  exit
fi

exec "$@"
