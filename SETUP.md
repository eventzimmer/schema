# Setting up the eventzimmer API

We use `PostgreSQL` alongside [PostgREST](http://postgrest.org) to host the `eventzimmer` API.

To set up the database locally, go like this:

```
docker run  -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 mdillon/postgis # set up a database

migrate -path migrations -database "postgresql://postgres:mysecretpassword@localhost:5432/postgres?sslmode=disable" up # initialise database

PGPASSWORD=mysecretpassword psql --user postgres -h localhost -c "\copy eventzimmer.sources FROM fixtures/sources.csv DELIMITER ',' CSV HEADER;" # insert sources

PGPASSWORD=mysecretpassword psql --user postgres -h localhost -c "\copy eventzimmer.locations FROM fixtures/locations.csv DELIMITER ',' CSV HEADER;" # insert locations

PGPASSWORD=mysecretpassword psql --user postgres -h localhost < fixtures/events.sql # insert events

postgrest configs/eventzimmer.conf # run PostgREST
```

Additionally, running `docker run -p 8080:8080 -e URL=http://localhost:3000 swaggerapi/swagger-ui` will provide a `Swagger UI` to the schema.
