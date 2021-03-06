#
# create and run a minimal alpine-based dev image
#

# host ~/.ssh is mounted into to the container 
# docker-cli is configured for the host docker engine via the unix socket

IMAGE=$(shell basename $(shell pwd))
USERNAME=$(shell id -un)
UID=$(shell id -u)
DOCKER_GID=$(shell grep docker /etc/group | cut -d: -f3) \

run: build
	docker run -it --rm \
	  -v ~/.ssh://home/${USERNAME}/.ssh \
	  -v /var/run/docker.sock:/var/run/docker.sock \
	  ${IMAGE}:latest

build:
	docker build \
	  --tag ${IMAGE} \
	  --build-arg USERNAME=${USERNAME} \
	  --build-arg UID=${UID} \
	  --build-arg DOCKER_GID=${DOCKER_GID} \
	  dev
