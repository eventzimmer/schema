# Setting up the eventzimmer API

We use `PostgreSQL` alongside [PostgREST](http://postgrest.org) to host the `eventzimmer` API.

To set up the database locally, go like this:

```
POSTGRES_PASSWORD=mysecretpassword docker-compose -f docker-compose.yml -f docker-compose.dev.yml up # fire up docker

migrate -path migrations -database "postgresql://postgres:mysecretpassword@localhost:5432/postgres?sslmode=disable" up # initialise database

PGPASSWORD=mysecretpassword psql --user postgres -h localhost -c "\copy eventzimmer.sources FROM fixtures/sources.csv DELIMITER ',' CSV HEADER;" # insert sources

PGPASSWORD=mysecretpassword psql --user postgres -h localhost -c "\copy eventzimmer.locations FROM fixtures/locations.csv DELIMITER ',' CSV HEADER;" # insert locations

PGPASSWORD=mysecretpassword psql --user postgres -h localhost < fixtures/events.sql # insert events

postgrest configs/eventzimmer.conf # run PostgREST
```

