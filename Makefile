
# PHP version
PHP_VERSION ?= 8.3

build:
	$(MAKE) -C docker build tag PHP_VERSION=$(PHP_VERSION)

build-dev:
	$(MAKE) -C docker build-dev tag PHP_VERSION=$(PHP_VERSION)

clean:
	docker rm  3liz-php-fpm 3liz-php-cli 3liz-php-web  || true
	$(MAKE) -C docker clean  PHP_VERSION=$(PHP_VERSION)
	$(MAKE) -C docker clean  PHP_VERSION=$(PHP_VERSION)

clean-all:
	docker rmi -f $(shell docker images 3liz/liz-php* -q)
