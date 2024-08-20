.PHONY: build run push clean

IMAGE=docker.io/take0a/mssql-nwnd-pubs
CONTAINER=mssql01
PASSWORD=Passw0rd!

build: clean
	docker build . -t $(IMAGE) --no-cache

run:
	docker run --name $(CONTAINER) -dit -e ACCEPT_EULA=Y -e MSSQL_SA_PASSWORD=$(PASSWORD) $(IMAGE)
	docker exec -it $(CONTAINER) /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $(PASSWORD)

push:
	docker push $(IMAGE)

clean:
	docker container rm $(CONTAINER) -f
	docker image rm $(IMAGE) -f
