eventzimmer
-----------

`schema` contains the code for the eventzimmer backend.

## Setting up the eventzimmer API

We use `PostgreSQL` alongside [PostgREST](http://postgrest.org) to host the `eventzimmer` API.

To get a local setup you will need to have the following tools installed on your machine:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

Within this directory, [follow the white rabbit](https://youtu.be/plfMjbnM2Ek?t=57):
```
POSTGRES_PASSWORD=mysecretpassword docker-compose up -d # fire up docker
./schema.sh bootstrap # bootstraps a new database
./schema.sh update # updates the events to be recent for development
docker-compose stop # if you want to stop the development setup
```

This will give you fresh copy of `schema` at [localhost:3000](localhost:3000) and it's documentation at [localhost:8080](localhost:8080).

On consecutive starts you only fire up the `Docker` containers, as their volume persists [until deleted](https://docs.docker.com/compose/reference/down/). To fire up the containers you must supply the `POSTGRES_PASSWORD` environment variable, since `PostgREST` does require it for authentication.

If you need introspection into the `Postgres` instance you can use the `psql` and `migrate` commands:

```
./schema.sh psql # will fire up a psql REPL
./schema.sh migrate help # will provide you a command line of go-migrate
```

### Creating new migrations

This project uses [go-migrate](https://github.com/golang-migrate/migrate) to manage migrations. To create a new migration you can use the command line:

```
./schema.sh migrate create -ext sql migration_name
```
