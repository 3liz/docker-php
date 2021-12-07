
# PHP version
PHP_VERSION ?= 7.4

build: build-fpm


build-cli:
	$(MAKE) -C php-cli build tag PHP_VERSION=$(PHP_VERSION)

build-fpm: build-cli
	$(MAKE) -C php-fpm build tag PHP_VERSION=$(PHP_VERSION)

clean:
	docker rm  3liz-php-fpm 3liz-php-cli 3liz-php-nginx  || true
	$(MAKE) -C php-cli clean  PHP_VERSION=$(PHP_VERSION)
	$(MAKE) -C php-fpm clean  PHP_VERSION=$(PHP_VERSION)


