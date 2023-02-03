FROM debian:bullseye-slim
MAINTAINER Laurent Jouanneau <laurent.jouanneau@3liz.com>

ARG composer_version=2.1.14
ARG php_version=8.1
ARG app_user_id=1000
ARG app_group_id=1000

ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VERSION=${php_version}

RUN set -eux; \
    echo 'alias ll="ls -al"' > /etc/profile.d/start; \
	apt-get update; \
    apt-get -y install apt-transport-https lsb-release ca-certificates curl wget git unzip gnupg2; \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg; \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'; \
    apt-get clean

RUN apt-get update;  \
    apt-get -y install \
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
    ; if [ "$PHP_VERSION" != "8.0" -a "$PHP_VERSION" != "8.1"  ]; then apt-get -y install \
        php${PHP_VERSION}-json \
    ; fi \
    ; \
    apt-get clean

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
