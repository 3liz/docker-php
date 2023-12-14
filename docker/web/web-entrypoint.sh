#!/usr/bin/env bash

if [ -f /etc/nginx/sites-enabled/site.conf ]; then

  rm -f /etc/nginx/sites-enabled/default.conf
else

    if [ "$WEB_ROOT_DIRECTORY" == "" ]; then
      WEB_ROOT_DIRECTORY="/app/"
    fi

    if [ "$SERVER_NAME" == "" ]; then
      SERVER_NAME="_"
    fi

    cp /etc/nginx/snippets/default.conf /etc/nginx/sites-enabled/default.conf

    sed -i "s#__SERVER_NAME__#$SERVER_NAME#g" /etc/nginx/sites-enabled/default.conf
    sed -i "s#__WEB_ROOT_DIRECTORY__#$WEB_ROOT_DIRECTORY#g" /etc/nginx/sites-enabled/default.conf
    sed -i "s#__HEADER__#$NGINX_HEADER#g" /etc/nginx/sites-enabled/default.conf
    sed -i "s#__FOOTER__#$NGINX_FOOTER#g" /etc/nginx/sites-enabled/default.conf

    cat /etc/nginx/sites-enabled/default.conf
fi

