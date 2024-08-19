.PHONY: build run push clean

IMAGE=docker.io/take0a/postgres-dellstore2
CONTAINER=postgres01
PASSWORD=password

build: clean
	gzip -k dellstore2-normal-1.0/*.sql 
	docker build . -t $(IMAGE) --no-cache

run:
	docker run --name $(CONTAINER) -dit -e POSTGRES_PASSWORD=$(PASSWORD) $(IMAGE)
	docker exec -it $(CONTAINER) /bin/bash

push:
	docker push $(IMAGE)

clean:
	docker container rm $(CONTAINER) -f
	docker image rm $(IMAGE) -f
	rm -f dellstore2-normal-1.0/*.sql.gz
