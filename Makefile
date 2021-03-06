#
#  An alpine-based dev image for python/docker/aws work
#
#   MIT Licensed
#
#   git@github.com/rstms/devbox
#   mkrueger@rstms.net
#

# Defaults:
# host ~/.ssh is mounted into to the container 
# docker-cli is configured for the host docker engine via the unix socket
# ./src is bind-mounted into container

PROJECT_NAME=rstms/devbox

all: run

config:
	dotenv set UID $(shell id -u)
	dotenv set USERNAME $(shell id -un)
	dotenv set DOCKER_GID $(shell grep docker /etc/group | cut -d: -f3)
	dotenv set VERSION $(shell cat VERSION)

run:
	./dev

build:
	docker-compose build
	git tag ${PROJECT_NAME}:$(shell cat VERSION) ${PROJECT_NAME}:latest

rebuild:
	docker-compose build --no-cache
	git tag ${PROJECT_NAME}:$(shell cat VERSION) ${PROJECT_NAME}:latest

# todo: determine if latest local image is newer than dockerhub
publish: build
	$(if $(wildcard ~/.docker/config.json),,$(error docker-publish failed; ~/.docker/config.json required))
	@echo publishing latest image to dockerhub
	docker login
	docker push ${PROJECT_NAME}:$(shell cat VERSION)
	docker push ${PROJECT_NAME}:latest

define bump
bumpversion $1;
dotenv set VERSION $$(cat VERSION);
endef

bump-patch:
	$(call bump,patch)

bump-minor:
	$(call bump,minor)

bump-major:
	$(call bump,major)

