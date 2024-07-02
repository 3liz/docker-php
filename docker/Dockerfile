FROM debian:bullseye-slim AS php-cli
LABEL org.opencontainers.image.authors="Laurent Jouanneau <laurent.jouanneau@3liz.com>"

ARG composer_version=2.7.7
ARG php_version=8.3
ARG app_user_id=1000
ARG app_group_id=1000

ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VERSION=${php_version}

RUN set -eux; \
    echo 'alias ll="ls -al"' > /etc/profile.d/start; \
	apt update && apt upgrade -y && apt install -y \
    apt-transport-https lsb-release ca-certificates curl wget git unzip gnupg2 \
    && rm -rf /var/lib/apt/lists/*; \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg; \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list';

RUN set -eux; \
    apt update;  \
    apt install -y \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dba \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-ldap \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-sqlite3 \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-memcache \
    php${PHP_VERSION}-memcached \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-uuid \
    php${PHP_VERSION}-yaml \
    ; if [ "$PHP_VERSION" = "7.4" ]; then apt install -y \
        php${PHP_VERSION}-json \
    ; fi \
    ; \
    rm -rf /var/lib/apt/lists/*;

## Install Composer
RUN wget -O /bin/composer https://getcomposer.org/download/$composer_version/composer.phar \
    && chmod +x /bin/composer && /bin/composer self-update

RUN set -eux; \
    echo "error_log = /var/log/php_cli_errors.log" >> /etc/php/${PHP_VERSION}/cli/conf.d/errorlog.ini; \
    touch /var/log/php_cli_errors.log; \
    addgroup --gid $app_group_id groupphp; \
    useradd --uid $app_user_id --gid $app_group_id -m userphp ; \
    mkdir /app/; \
    mkdir /bin/entrypoint.d

COPY entrypoint.sh /bin/
COPY helpers.sh /bin/
RUN chmod 755 /bin/entrypoint.sh /bin/helpers.sh

WORKDIR /app/
ENTRYPOINT ["/bin/entrypoint.sh"]
#CMD ["tail", "-f", "/var/log/php_cli_errors.log"]

FROM php-cli AS php-fpm

RUN apt update && apt install -y \
    php${PHP_VERSION}-fpm \
    && rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
    ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm; \
    mkdir -p /run/php/;

COPY www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY fpm-entrypoint.sh /bin/entrypoint.d/
COPY default-php-fpm /etc/default/php-fpm

RUN chmod +x /bin/entrypoint.d/fpm-entrypoint.sh

CMD ["/usr/sbin/php-fpm", "-F", "-O"]

FROM php-fpm AS php-web

RUN apt update && apt install -y \
    nginx \
    nginx-common \
    nginx-extras \
    supervisor \
    && rm -rf /var/lib/apt/lists/*;

RUN  mkdir /var/log/docker-php/; \
     rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default;

COPY web/nginx/snippets/ /etc/nginx/snippets/
COPY web/supervisord.conf /etc/supervisor/supervisord.conf
COPY web/supervisord_workers.conf /etc/supervisor/conf.d/
COPY web/web-entrypoint.sh /bin/entrypoint.d/

RUN chmod +x /bin/entrypoint.d/web-entrypoint.sh

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
