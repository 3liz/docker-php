

PHP_VERSION ?= 7.4

BUILD_ID=$(shell date +"%Y%m%d%H%M")
COMMIT_ID=$(shell git rev-parse --short HEAD)
BUILD_TAG=$(PHP_VERSION)-$(COMMIT_ID)-$(BUILD_ID)
BUILD_ARGS=--build-arg php_version=$(PHP_VERSION)

build-cli:
	docker build -t 3liz/php-cli:$(BUILD_TAG) -t 3liz/php-cli:$(PHP_VERSION) $(BUILD_ARGS) php-cli/


build-fpm: build-cli
	docker build -t 3liz/php-fpm:$(BUILD_TAG) -t 3liz/php-fpm:$(PHP_VERSION) $(BUILD_ARGS) php-fpm/

clean:
	docker rm  3liz-php-fpm 3liz-php-cli 3liz-php-nginx  || true
	docker rmi -f $(shell docker images --filter=reference='3liz/php-*' -q) || true




