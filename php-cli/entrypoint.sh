#!/bin/sh


egrep -i "^groupphp" /etc/group;
if [ $? -eq 0 ]; then
   groupmod -g $APP_GROUP_ID groupphp
else
  addgroup --gid $APP_GROUP_ID groupphp;
fi

egrep -i "^userphp:" /etc/passwd;
if [ $? -eq 0 ]; then
   usermod -u $APP_USER_ID userphp
else
   useradd --uid $APP_USER_ID --gid $APP_GROUP_ID userphp;
fi

for entry in /bin/entrypoint.d/*
do
  source $entry
done

set -e
set -x

echo "launch exec $@"
exec "$@"
