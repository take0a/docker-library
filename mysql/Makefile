.PHONY: build run push clean

IMAGE=docker.io/take0a/mysql-sakila
CONTAINER=mysql01
PASSWORD=password

build: clean
	gzip -k sakila-db/*.sql 
	docker build . -t $(IMAGE) --no-cache

run:
	docker run --name $(CONTAINER) -dit -e MYSQL_ROOT_PASSWORD=$(PASSWORD) $(IMAGE)
	docker exec -it $(CONTAINER) /usr/bin/mysql -p

push:
	docker push $(IMAGE)

clean:
	docker container rm $(CONTAINER) -f
	docker image rm $(IMAGE) -f
	rm -f sakila-db/*.sql.gz
