SHELL:=bash
# 
# Build docker image
#
#

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

# PHP version
PHP_VERSION ?= 8.1

BUILD_ARGS += --build-arg php_version=$(PHP_VERSION)

REGISTRY_URL ?= 3liz
REGISTRY_PREFIX=$(REGISTRY_URL)/
BUILD_ARGS += --build-arg REGISTRY_PREFIX=$(REGISTRY_PREFIX)

CLINAME=liz-php-cli
CLIBUILDIMAGE:=$(CLINAME):$(PHP_VERSION)-$(COMMITID)
CLIMANIFEST=factory-cli.manifest

FPMNAME=liz-php-fpm
FPMBUILDIMAGE:=$(FPMNAME):$(PHP_VERSION)-$(COMMITID)
FPMMANIFEST=factory-fpm.manifest

all:
	@echo "Usage: make [build|deliver|clean]"

build: _build manifest

_build:
	docker build --rm --force-rm --no-cache $(DOCKER_BUILD_ARGS) \
		$(BUILD_ARGS) -t $(CLIBUILDIMAGE)  --target=php-cli $(DOCKERFILE) .
	docker build --rm --force-rm --no-cache $(DOCKER_BUILD_ARGS) \
		$(BUILD_ARGS) -t $(FPMBUILDIMAGE)  --target=php-fpm $(DOCKERFILE) .

build-dev: _build-dev manifest

_build-dev:
	docker build $(DOCKER_BUILD_ARGS) $(BUILD_ARGS) -t $(CLIBUILDIMAGE) --target=php-cli $(DOCKERFILE) .
	docker build $(DOCKER_BUILD_ARGS) $(BUILD_ARGS) -t $(FPMBUILDIMAGE) --target=php-fpm $(DOCKERFILE) .

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
	echo commitid=$(COMMITID) >> $(FPMMANIFEST); }

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
	}

push:
	{ set -e; source $(CLIMANIFEST); \
	docker push $(REGISTRY_URL)/$(CLINAME):$${release_tag}-$(TAG_DEV); \
	source $(FPMMANIFEST); \
	docker push $(REGISTRY_URL)/$(FPMNAME):$${release_tag}-$(TAG_DEV); \
	}
else
tag:
	{ set -e; source $(CLIMANIFEST); \
	docker tag $(CLIBUILDIMAGE) $(REGISTRY_PREFIX)$(CLINAME):$$version; \
	docker tag $(CLIBUILDIMAGE) $(REGISTRY_PREFIX)$(CLINAME):$$release_tag; \
	source $(FPMMANIFEST); \
	docker tag $(FPMBUILDIMAGE) $(REGISTRY_PREFIX)$(FPMNAME):$$version; \
	docker tag $(FPMBUILDIMAGE) $(REGISTRY_PREFIX)$(FPMNAME):$$release_tag; \
	}

push:
	{ set -e; source $(CLIMANIFEST); \
	docker push $(REGISTRY_URL)/$(CLINAME):$$version; \
	docker push $(REGISTRY_URL)/$(CLINAME):$$release_tag; \
	source $(FPMMANIFEST); \
	docker push $(REGISTRY_URL)/$(FPMNAME):$$version; \
	docker push $(REGISTRY_URL)/$(FPMNAME):$$release_tag; \
	}
endif

clean-all:
	docker rmi -f $(shell docker images $(CLIBUILDIMAGE) -q)
	docker rmi -f $(shell docker images $(FPMBUILDIMAGE) -q)

clean:
	 docker rmi $(CLIBUILDIMAGE)
	 docker rmi $(FPMBUILDIMAGE)
