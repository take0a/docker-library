.PHONY: build run push clean

IMAGE=docker.io/take0a/maria-htap
CONTAINER=maria01
PASSWORD=password

build: clean
	docker build . -t $(IMAGE) --no-cache

run:
	docker run --name $(CONTAINER) -dit -e MARIADB_ROOT_PASSWORD=$(PASSWORD) $(IMAGE)
	docker exec -it $(CONTAINER) /bin/bash

push:
	docker push $(IMAGE)

clean:
	docker container rm $(CONTAINER) -f
	docker image rm $(IMAGE) -f
