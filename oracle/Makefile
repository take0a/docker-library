.PHONY: build run push clean

IMAGE=docker.io/take0a/oracle-co
CONTAINER=oracle01
PASSWORD=password

build: clean
	docker build . -t $(IMAGE) --no-cache

run:
	docker run --name $(CONTAINER) -dit -e ORACLE_PWD=$(PASSWORD) $(IMAGE)
	docker exec -it $(CONTAINER) /bin/bash

push:
	docker push $(IMAGE)

clean:
	docker container rm $(CONTAINER) -f
	docker image rm $(IMAGE) -f
