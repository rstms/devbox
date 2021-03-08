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

DEV=./devbox/scripts/dev


help:
	@echo Targets: config dev run build rebuild publish bump-major bump-minor bump-patch

config:
	dotenv set UID $$(id -u)
	dotenv set USERNAME $$(id -un)
	dotenv set DOCKER_GID $$(grep docker /etc/group | cut -d: -f3)
	dotenv set VERSION $$(cat VERSION)

dev:
	@${DEV}

run:
	docker run -it --rm ${PROJECT_NAME}:latest 

build:
	docker-compose build
	docker image tag ${PROJECT_NAME}:$$(cat VERSION) ${PROJECT_NAME}:latest

rebuild:
	docker-compose build --no-cache
	docker image tag ${PROJECT_NAME}:$$(cat VERSION) ${PROJECT_NAME}:latest

# todo: determine if latest local image is newer than dockerhub
publish: build
	$(if $(wildcard ~/.docker/config.json),,$(error docker-publish failed; ~/.docker/config.json required))
	@echo publishing latest image to dockerhub
	docker login
	docker push ${PROJECT_NAME}:$$(cat VERSION)
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

