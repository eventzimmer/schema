# Setting up the eventzimmer API

We use `PostgreSQL` alongside [PostgREST](http://postgrest.org) to host the `eventzimmer` API.

To get a local setup you will need to have the following tools installed on your machine:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [migrate](https://github.com/golang-migrate/migrate)
- [psql](https://www.postgresql.org/docs/9.2/app-psql.html)

Within this directory, follow the white rabbit:
```
POSTGRES_PASSWORD=mysecretpassword docker-compose -f docker-compose.yml -f docker-compose.dev.yml up # fire up docker

migrate -path migrations -database "postgresql://postgres:mysecretpassword@localhost:5432/postgres?sslmode=disable" up # initialise database

PGPASSWORD=mysecretpassword psql --user postgres -h localhost -c "\copy eventzimmer.sources FROM fixtures/sources.csv DELIMITER ',' CSV HEADER;" # insert sources

PGPASSWORD=mysecretpassword psql --user postgres -h localhost -c "\copy eventzimmer.locations FROM fixtures/locations.csv DELIMITER ',' CSV HEADER;" # insert locations

PGPASSWORD=mysecretpassword psql --user postgres -h localhost < fixtures/events.sql # insert events
```

You may need to restart the services after initial setup. On consecutive starts you only fire up the `Docker` containers, as their volume persists [until deleted](https://docs.docker.com/compose/reference/down/).

To fire up the containers you must supply the `POSTGRES_PASSWORD` environment variable, since `PostgREST` does require it for authentication.

```
POSTGRES_PASSWORD=mysecretpassword docker-compose -f docker-compose.yml -f docker-compose.dev.yml up # fire up docker
```

If you need introspection into the `Postgres` instance you can use `psql`:

```
PGPASSWORD=mysecretpassword psql --user postgres -h localhost
```
