ARG php_version=7.4
ARG REGISTRY_PREFIX=''

FROM ${REGISTRY_PREFIX}liz-php-cli:${php_version}
MAINTAINER Laurent Jouanneau <laurent.jouanneau@3liz.com>

ARG php_version
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VERSION=${php_version}

RUN apt-get -y install \
    php${PHP_VERSION}-fpm \
    ; \
    apt-get clean

RUN set -eux; \
    ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm; \
    mkdir -p /run/php/;

COPY www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY fpm-entrypoint.sh /bin/entrypoint.d/
COPY default-php-fpm /etc/default/php-fpm

RUN chmod +x /bin/entrypoint.d/fpm-entrypoint.sh

CMD ["/usr/sbin/php-fpm", "-F", "-O"]
