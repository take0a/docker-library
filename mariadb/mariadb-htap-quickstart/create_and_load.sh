#!/bin/bash

# You can change from using root here
#user=$1
#pass=$2
#mariadb+=" --user ${user} -p${pass}"

mariadb="mariadb --user root -p${MARIADB_ROOT_PASSWORD}"

echo "creating schema..."

# Create travel database and airports, airlines, flights tables
${mariadb} < /docker-entrypoint-initdb.d/sql/schema.sql

echo "schema created"
echo "loading data..."

# Load airlines into travel.airlines
${mariadb} -e "LOAD DATA LOCAL INFILE '/docker-entrypoint-initdb.d/data/airlines.csv' INTO TABLE airlines FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n'" innodb_db

echo '- airlines.csv loaded into innodb_db.airlines'

# Load airports into travel.airlines
${mariadb} -e "LOAD DATA LOCAL INFILE '/docker-entrypoint-initdb.d/data/airports.csv' INTO TABLE airports FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n'" innodb_db
echo '- airports.csv loaded into innodb_db.airports'

# Load flights data into travel_history.flights
# cpimport "columnstore_db" "flights" "/docker-entrypoint-initdb.d/data/flights.csv" -s "," -E '"'