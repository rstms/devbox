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

config: dotenv

dotenv:
	dotenv set UID $(shell id -u)
	dotenv set USERNAME $(shell id -un)
	dotenv set DOCKER_GID $(shell grep docker /etc/group | cut -d: -f3)
	dotenv set VERSION $(shell cat VERSION)

run:
	docker-compose up --build devbox

build: dotenv
	docker-compose build

rebuild: dotenv
	docker-compose build --no-cache

# todo: determine if latest local image is newer than dockerhub
publish:
	$(if $(wildcard ~/.docker/config.json),,$(error docker-publish failed; ~/.docker/config.json required))
	@echo publishing latest image to dockerhub
	docker login
	docker push ${PROJECT_NAME}:$(shell cat VERSION)
	docker push ${PROJECT_NAME}:latest

bump-patch:
	bumpversion patch

bump-minor:
	bumpversion patch

bump-major:
	bumpversion patch
