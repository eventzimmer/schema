eventzimmer
-----------

`schema` contains the code for the eventzimmer backend.

## Setting up the eventzimmer API

We use `PostgreSQL` alongside [PostgREST](http://postgrest.org) to host the `eventzimmer` API.

To get a local setup you will need to have the following tools installed on your machine:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

Within this directory, follow the white rabbit:
```
POSTGRES_PASSWORD=mysecretpassword docker-compose -f docker-compose.yml -f docker-compose.dev.yml up # fire up docker

docker run -v $PWD/migrations:/migrations/ --network="container:schema_db_1" migrate/migrate -path=/migrations -database "postgresql://postgres:mysecretpassword@schema_db_1:5432/postgres?sslmode=disable" up 1 # initialise database

docker exec -i -e PGPASSWORD=mysecretpassword schema_db_1 psql --user postgres -h localhost -c "\copy eventzimmer.sources FROM /fixtures/sources.csv DELIMITER ',' CSV HEADER;" # insert sources

docker exec -i -e PGPASSWORD=mysecretpassword schema_db_1 psql --user postgres -h localhost -c "\copy eventzimmer.locations FROM fixtures/locations.csv DELIMITER ',' CSV HEADER;" # insert locations

docker exec -i -e PGPASSWORD=mysecretpassword schema_db_1 bash -c "psql --user postgres -h localhost < /fixtures/events.sql" # insert events

docker run -v $PWD/migrations:/migrations/ --network="container:schema_db_1" migrate/migrate -path=/migrations -database "postgresql://postgres:mysecretpassword@schema_db_1:5432/postgres?sslmode=disable" up # add remaining migrations
```

You may need to restart the services after initial setup. On consecutive starts you only fire up the `Docker` containers, as their volume persists [until deleted](https://docs.docker.com/compose/reference/down/).

To fire up the containers you must supply the `POSTGRES_PASSWORD` environment variable, since `PostgREST` does require it for authentication.

```
POSTGRES_PASSWORD=mysecretpassword docker-compose -f docker-compose.yml -f docker-compose.dev.yml up # fire up docker
```

If you need introspection into the `Postgres` instance you can use `docker exec`:

```
docker exec -it -e PGPASSWORD=mysecretpassword schema_db_1 psql --user postgres -h localhost
```
