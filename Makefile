

PHP_VERSION ?= 7.4

build-cli:
	docker build -t jelix/php-cli:$(PHP_VERSION) --build-arg php_version=$(PHP_VERSION) php-cli/


build-fpm: build-cli
	docker build -t jelix/php-fpm:$(PHP_VERSION) --build-arg php_version=$(PHP_VERSION) php-fpm/
