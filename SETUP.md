# Setting up the eventzimmer API

We use `PostgreSQL` alongside [PostgREST](http://postgrest.org) to host the `eventzimmer` API.

To set up the database locally, go like this:

```
docker run  -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 mdillon/postgis # set up a database

PGPASSWORD=mysecretpassword psql -h localhost --user postgres  < eventzimmer.sql # bootstrap tables

PGPASSWORD=mysecretpassword psql --user postgres -h localhost -c "\copy eventzimmer.sources FROM fixtures/sources.csv DELIMITER ',' CSV HEADER;" # insert sources

PGPASSWORD=mysecretpassword psql --user postgres -h localhost -c "\copy eventzimmer.locations FROM fixtures/locations.csv DELIMITER ',' CSV HEADER;" # insert locations

PGPASSWORD=mysecretpassword psql --user postgres -h localhost < fixtures/events.sql # insert events
```

The `PostgREST` server can the be ran via `./postgrest eventzimmer.conf`.

Additionally, running `docker run -p 8080:8080 -e URL=HTTP://LOCALHOST:3000 swaggerapi/swagger-ui` will provide a `Swagger UI` to the schema.
