FROM mysql
COPY ./sakila-db/sakila-schema.sql.gz /docker-entrypoint-initdb.d/01.sql.gz
COPY ./sakila-db/sakila-data.sql.gz /docker-entrypoint-initdb.d/02.sql.gz
