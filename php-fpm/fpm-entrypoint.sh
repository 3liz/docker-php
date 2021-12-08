
if [ "$DISPLAY_ERRORS" == "on" ]; then
    sed -i "/^display_errors =/c\display_errors = On" /etc/php/${PHP_VERSION}/fpm/php.ini; \
else
    sed -i "/^display_errors =/c\display_errors = Off" /etc/php/${PHP_VERSION}/fpm/php.ini; \
fi

sed -i "/^user =/c\user = $APP_USER_NAME" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf; \
sed -i "/^group =/c\group = $APP_GROUP_NAME" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf; \
