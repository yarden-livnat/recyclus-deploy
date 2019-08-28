# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

include .env

.DEFAULT_GOAL=build

network:
#	@docker network inspect $(DOCKER_NETWORK_NAME) >/dev/null 2>&1 || docker network create $(DOCKER_NETWORK_NAME)

volumes:
	@docker volume inspect $(DATA_VOLUME_HOST) >/dev/null 2>&1 || docker volume create --name $(HUB_DATA_VOLUME)


check-files: secrets/oauth-forward.env

pull:
	docker pull $(DOCKER_NOTEBOOK_IMAGE)

notebook_image: pull singleuser/Dockerfile
	docker build -t $(LOCAL_NOTEBOOK_IMAGE) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		--build-arg DOCKER_NOTEBOOK_IMAGE=$(DOCKER_NOTEBOOK_IMAGE) \
		singleuser

build: check-files network volumes
	docker-compose build



# docker swarm
#

define swarm-status
$(shell docker info | grep Swarm | sed 's/Swarm: //g')
endef

start:
ifeq ($(swarm-status),inactive)
	docker swarm init
endif
	docker stack deploy -c docker-stack.yml recyclus
	docker service ls

stop:
	docker stack rm recyclus

exit:
	docker swarm leave --force

.PHONY: network volumes check-files pull notebook_image build
