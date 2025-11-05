SHELL:=bash
# 
# Build docker image
#
#

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

# PHP version
PHP_VERSION ?= 8.3

ifeq ($(PHP_VERSION),7.4)
  DEBIAN_VERSION=bullseye
else ifeq ($(PHP_VERSION),8.0)
  DEBIAN_VERSION=bullseye
else ifeq ($(PHP_VERSION),8.1)
  DEBIAN_VERSION=bullseye
else ifeq ($(PHP_VERSION),8.2)
  DEBIAN_VERSION=bookworm
else ifeq ($(PHP_VERSION),8.3)
  DEBIAN_VERSION=bookworm
else ifeq ($(PHP_VERSION),8.4)
  DEBIAN_VERSION=bookworm
else
  DEBIAN_VERSION=trixie
endif

BUILD_ARGS += --build-arg php_version=$(PHP_VERSION) --build-arg debian_version=$(DEBIAN_VERSION)

REGISTRY_URL ?= 3liz
REGISTRY_PREFIX=$(REGISTRY_URL)/
BUILD_ARGS += --build-arg REGISTRY_PREFIX=$(REGISTRY_PREFIX)

CLINAME=liz-php-cli
CLIBUILDIMAGE:=$(CLINAME):$(PHP_VERSION)-$(COMMITID)
CLIMANIFEST=factory-cli.manifest

FPMNAME=liz-php-fpm
FPMBUILDIMAGE:=$(FPMNAME):$(PHP_VERSION)-$(COMMITID)
FPMMANIFEST=factory-fpm.manifest

WEBFPMNAME=liz-php-web
WEBFPMBUILDIMAGE:=$(WEBFPMNAME):$(PHP_VERSION)-$(COMMITID)
WEBFPMMANIFEST=factory-web.manifest

all:
	@echo "Usage: make [build|deliver|clean]"

build: _build manifest

_build:
	docker build --rm --force-rm --no-cache $(DOCKER_BUILD_ARGS) \
		$(BUILD_ARGS) -t $(CLIBUILDIMAGE)  --target=php-cli $(DOCKERFILE) .
	docker build --rm --force-rm  $(DOCKER_BUILD_ARGS) \
		$(BUILD_ARGS) -t $(FPMBUILDIMAGE)  --target=php-fpm $(DOCKERFILE) .
	docker build --rm --force-rm  $(DOCKER_BUILD_ARGS) \
		$(BUILD_ARGS) -t $(WEBFPMBUILDIMAGE)  --target=php-web $(DOCKERFILE) .

build-dev: _build-dev manifest

_build-dev:
	docker build $(DOCKER_BUILD_ARGS) $(BUILD_ARGS) -t $(CLIBUILDIMAGE) --target=php-cli $(DOCKERFILE) .
	docker build $(DOCKER_BUILD_ARGS) $(BUILD_ARGS) -t $(FPMBUILDIMAGE) --target=php-fpm $(DOCKERFILE) .
	docker build $(DOCKER_BUILD_ARGS) $(BUILD_ARGS) -t $(WEBFPMBUILDIMAGE) --target=php-web $(DOCKERFILE) .

manifest: 
	{ \
	set -e; \
	version_scripts=`cat ../VERSION`; \
	version=`echo $$PHP_VERSION`-`echo $$version_scripts`; \
	release_tag=`echo $$PHP_VERSION`; \
	echo name=$(CLINAME) > $(CLIMANIFEST) && \
    echo version=$$version >> $(CLIMANIFEST) && \
    echo release_tag=$$release_tag >> $(CLIMANIFEST) && \
    echo buildid=$(BUILDID)   >> $(CLIMANIFEST) && \
    echo commitid=$(COMMITID) >> $(CLIMANIFEST); \
	echo name=$(FPMNAME) > $(FPMMANIFEST) && \
	echo version=$$version >> $(FPMMANIFEST) && \
	echo release_tag=$$release_tag >> $(FPMMANIFEST) && \
	echo buildid=$(BUILDID)   >> $(FPMMANIFEST) && \
	echo commitid=$(COMMITID) >> $(FPMMANIFEST); \
	echo name=$(WEBFPMNAME) > $(WEBFPMMANIFEST) && \
	echo version=$$version >> $(WEBFPMMANIFEST) && \
	echo release_tag=$$release_tag >> $(WEBFPMMANIFEST) && \
	echo buildid=$(BUILDID)   >> $(WEBFPMMANIFEST) && \
	echo commitid=$(COMMITID) >> $(WEBFPMMANIFEST); \
	}

deliver: tag push

ifndef CI_COMMIT_TAG

TAG_DEV=dev

tag:
	{ set -e; source $(CLIMANIFEST); \
	docker tag $(CLIBUILDIMAGE) $(REGISTRY_PREFIX)$(CLINAME):$${release_tag}-$(TAG_DEV); \
	docker tag $(CLIBUILDIMAGE) $(REGISTRY_PREFIX)$(CLINAME):$${release_tag}; \
	source $(FPMMANIFEST); \
	docker tag $(FPMBUILDIMAGE) $(REGISTRY_PREFIX)$(FPMNAME):$${release_tag}-$(TAG_DEV); \
	docker tag $(FPMBUILDIMAGE) $(REGISTRY_PREFIX)$(FPMNAME):$${release_tag}; \
	source $(WEBFPMMANIFEST); \
	docker tag $(WEBFPMBUILDIMAGE) $(REGISTRY_PREFIX)$(WEBFPMNAME):$${release_tag}-$(TAG_DEV); \
	docker tag $(WEBFPMBUILDIMAGE) $(REGISTRY_PREFIX)$(WEBFPMNAME):$${release_tag}; \
	}

push:
	{ set -e; source $(CLIMANIFEST); \
	docker push $(REGISTRY_URL)/$(CLINAME):$${release_tag}-$(TAG_DEV); \
	source $(FPMMANIFEST); \
	docker push $(REGISTRY_URL)/$(FPMNAME):$${release_tag}-$(TAG_DEV); \
	source $(WEBFPMMANIFEST); \
	docker push $(REGISTRY_URL)/$(WEBFPMNAME):$${release_tag}-$(TAG_DEV); \
	}
else
tag:
	{ set -e; source $(CLIMANIFEST); \
	docker tag $(CLIBUILDIMAGE) $(REGISTRY_PREFIX)$(CLINAME):$$version; \
	docker tag $(CLIBUILDIMAGE) $(REGISTRY_PREFIX)$(CLINAME):$$release_tag; \
	source $(FPMMANIFEST); \
	docker tag $(FPMBUILDIMAGE) $(REGISTRY_PREFIX)$(FPMNAME):$$version; \
	docker tag $(FPMBUILDIMAGE) $(REGISTRY_PREFIX)$(FPMNAME):$$release_tag; \
	source $(WEBFPMMANIFEST); \
	docker tag $(WEBFPMBUILDIMAGE) $(REGISTRY_PREFIX)$(WEBFPMNAME):$$version; \
	docker tag $(WEBFPMBUILDIMAGE) $(REGISTRY_PREFIX)$(WEBFPMNAME):$$release_tag; \
	}

push:
	{ set -e; source $(CLIMANIFEST); \
	docker push $(REGISTRY_URL)/$(CLINAME):$$version; \
	docker push $(REGISTRY_URL)/$(CLINAME):$$release_tag; \
	source $(FPMMANIFEST); \
	docker push $(REGISTRY_URL)/$(FPMNAME):$$version; \
	docker push $(REGISTRY_URL)/$(FPMNAME):$$release_tag; \
	source $(WEBFPMMANIFEST); \
	docker push $(REGISTRY_URL)/$(WEBFPMNAME):$$version; \
	docker push $(REGISTRY_URL)/$(WEBFPMNAME):$$release_tag; \
	}
endif

clean-all:
	docker rmi -f $(shell docker images $(CLIBUILDIMAGE) -q)
	docker rmi -f $(shell docker images $(FPMBUILDIMAGE) -q)
	docker rmi -f $(shell docker images $(WEBFPMBUILDIMAGE) -q)

clean:
	 docker rmi $(CLIBUILDIMAGE)
	 docker rmi $(FPMBUILDIMAGE)
	 docker rmi $(WEBFPMBUILDIMAGE)
