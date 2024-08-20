FROM mariadb
COPY ./mariadb-htap-quickstart/create_and_load.sh /docker-entrypoint-initdb.d/01.sh
COPY ./mariadb-htap-quickstart/sql/schema.sql /docker-entrypoint-initdb.d/sql/schema.sql
COPY ./mariadb-htap-quickstart/data/airlines.csv /docker-entrypoint-initdb.d/data/airlines.csv
COPY ./mariadb-htap-quickstart/data/airports.csv /docker-entrypoint-initdb.d/data/airports.csv
# COPY ./mariadb-htap-quickstart/data/flights.csv /docker-entrypoint-initdb.d/data/flights.csv
