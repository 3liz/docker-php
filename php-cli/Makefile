SHELL:=bash
# 
# Build docker image
#
#

NAME=liz-php-cli

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

# PHP version
PHP_VERSION ?= 7.4

BUILD_ARGS += --build-arg php_version=$(PHP_VERSION)

REGISTRY_URL ?= 3liz
REGISTRY_PREFIX=$(REGISTRY_URL)/
BUILD_ARGS += --build-arg REGISTRY_PREFIX=$(REGISTRY_PREFIX)

BUILDIMAGE:=$(NAME):$(PHP_VERSION)-$(COMMITID)

MANIFEST=factory.manifest

all:
	@echo "Usage: make [build|deliver|clean]"

build: _build manifest

_build:
	docker build --rm --force-rm --no-cache $(DOCKER_BUILD_ARGS) \
		$(BUILD_ARGS) -t $(BUILDIMAGE) $(DOCKERFILE) .


manifest: 
	{ \
	set -e; \
	version_scripts=`cat ../VERSION`; \
	version=`echo $$PHP_VERSION`-`echo $$version_scripts`; \
	release_tag=`echo $$PHP_VERSION`; \
	echo name=$(NAME) > $(MANIFEST) && \
    echo version=$$version >> $(MANIFEST) && \
    echo release_tag=$$release_tag >> $(MANIFEST) && \
    echo buildid=$(BUILDID)   >> $(MANIFEST) && \
    echo commitid=$(COMMITID) >> $(MANIFEST); }

deliver: tag push

ifndef CI_COMMIT_TAG

GIT_BRANCH=$(shell git branch --show-current)
ifeq ($(GIT_BRANCH),)
GIT_BRANCH=$(CI_COMMIT_BRANCH)
endif

ifeq ($(GIT_BRANCH),main)
TAG_DEV=dev
else
TAG_DEV=$(GIT_BRANCH)-dev
endif

tag:
	{ set -e; source $(MANIFEST); \
	docker tag $(BUILDIMAGE) $(REGISTRY_PREFIX)$(NAME):$${release_tag}-$(TAG_DEV); \
	docker tag $(BUILDIMAGE) $(REGISTRY_PREFIX)$(NAME):$${release_tag}; \
	}

push:
	{ set -e; source $(MANIFEST); \
	docker push $(REGISTRY_URL)/$(NAME):$${release_tag}-$(TAG_DEV); \
	}
else
tag:
	{ set -e; source $(MANIFEST); \
	docker tag $(BUILDIMAGE) $(REGISTRY_PREFIX)$(NAME):$$version; \
	docker tag $(BUILDIMAGE) $(REGISTRY_PREFIX)$(NAME):$$release_tag; \
	}

push:
	{ set -e; source $(MANIFEST); \
	docker push $(REGISTRY_URL)/$(NAME):$$version; \
	docker push $(REGISTRY_URL)/$(NAME):$$release_tag; \
	}
endif

clean-all:
	docker rmi -f $(shell docker images $(BUILDIMAGE) -q)

clean:
	 docker rmi $(BUILDIMAGE)
