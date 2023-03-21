#!/bin/make

SHELL := /bin/bash

build:
	docker network create redis-dump-network
	docker volume create redis-dump-volume
	docker build src/redis/. --tag redis-dump-db-image
	docker build src/storage/. --tag redis-dump-storage-image

run:
	docker run --detach \
		--name redis-dump-db-container \
		--network redis-dump-network \
		--volume redis-dump-volume:/data \
		redis-dump-db-image
	docker run --detach \
		--name redis-dump-storage-container \
		--network redis-dump-network \
		--volume redis-dump-volume:/data \
		redis-dump-storage-image

stop:
	docker stop redis-dump-db-container redis-dump-storage-container

start:
	docker start redis-dump-db-container redis-dump-storage-container

rm:
	make stop --ignore-errors
	docker rm redis-dump-db-container redis-dump-storage-container

teardown:
	make rm --ignore-errors
	docker network rm redis-dump-network
	docker volume rm redis-dump-volume

redis-cli:
	docker exec --interactive --tty redis-dump-db-container redis-cli

ssh-into-redis:
	docker exec --interactive --tty redis-dump-db-container bash

storage-logs:
	docker logs redis-dump-storage-container

aws-configure:
	docker exec --interactive --tty redis-dump-storage-container bash configure_bucket.sh
	docker exec --interactive --tty redis-dump-storage-container aws configure
