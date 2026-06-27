
SRCS := srcs/
THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help build up start down destroy stop restart logs logs-api ps login-timescale login-api db-shell


help:
	@make -pRrq  -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
build:
	docker-compose -f $(SRCS)docker-compose.yml build $(c)
up:
	docker-compose -f $(SRCS)docker-compose.yml up $(c)
start:
	docker-compose -f $(SRCS)docker-compose.yml start $(c)
down:
	docker-compose -f $(SRCS)docker-compose.yml down $(c)
destroy:
	docker-compose -f $(SRCS)docker-compose.yml down -v $(c)
stop:
	docker-compose -f $(SRCS)docker-compose.yml stop $(c)
restart:
	docker-compose -f $(SRCS)docker-compose.yml stop $(c)
	docker-compose -f $(SRCS)docker-compose.yml up $(c)
logs:
	docker-compose -f $(SRCS)docker-compose.yml logs --tail=100 -f $(c)
logs-api:
	docker-compose -f $(SRCS)docker-compose.yml logs --tail=100 -f api
ps:
	docker-compose -f $(SRCS)docker-compose.yml ps
login-timescale:
	docker-compose -f $(SRCS)docker-compose.yml exec timescale /bin/bash
login-api:
	docker-compose -f $(SRCS)docker-compose.yml exec api /bin/bash
db-shell:
	docker-compose -f $(SRCS)docker-compose.yml exec timescale psql -Upostgres
