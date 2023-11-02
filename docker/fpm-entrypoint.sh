
if [ "$DISPLAY_ERRORS" == "on" ]; then
    sed -i "/^display_errors =/c\display_errors = On" /etc/php/${PHP_VERSION}/fpm/php.ini;
else
    sed -i "/^display_errors =/c\display_errors = Off" /etc/php/${PHP_VERSION}/fpm/php.ini;
fi
