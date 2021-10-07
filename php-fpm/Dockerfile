ARG php_version=7.4

FROM jelix/php-cli:${php_version}

ARG php_version
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VERSION=${php_version}

RUN apt-get -y install \
    php${PHP_VERSION}-fpm \
    ; \
    apt-get clean

RUN set -eux; \
    sed -i "/^display_errors =/c\display_errors = On" /etc/php/${PHP_VERSION}/fpm/php.ini; \
    ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm; \
    mkdir -p /run/php/;

COPY www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

CMD ["/usr/sbin/php-fpm", "-F", "-O"]
