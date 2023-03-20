#!/bin/make

SHELL := /bin/bash

build:
	docker network create redis-dump-network
	docker volume create redis-dump-volume
	docker build redis/. --tag redis-dump-db-image

run:
	docker run --detach \
		--name redis-dump-db-container \
		--network redis-dump-network \
		--volume redis-dump-volume:/data \
		redis-dump-db-image

stop:
	docker stop redis-dump-db-container

start:
	docker start redis-dump-db-container

rm:
	make stop --ignore-errors
	docker rm redis-dump-db-container

teardown:
	make rm --ignore-errors
	docker network rm redis-dump-network
	docker volume rm redis-dump-volume

redis-cli:
	docker exec --interactive --tty redis-dump-db-container redis-cli

ssh-into-redis:
	docker exec --interactive --tty redis-dump-db-container bash
