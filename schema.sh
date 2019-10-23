#!/bin/sh

program_name=$(basename $0)
pg_password="${PGPASSWORD:-mysecretpassword}"
container_name="${CONTAINER_NAME:-schema_db_1}"
  
sub_help(){
    echo "Usage: $program_name <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    bootstrap   Bootstraps a new database with fixtures and migrations"
    echo "    update      Sets a recent starts_at date for all events"
    echo "    psql        Attaches a psql REPL to the database"
    echo "    migrate     Runs a migrate instance against the database"
    echo ""
    echo "For help with each subcommand run:"
    echo "$program_name <subcommand> -h|--help"
    echo ""
}

sub_update(){
    echo "Updating all event start dates."
    docker exec -i -e PGPASSWORD=$pg_password $container_name psql --user postgres -h localhost -c "UPDATE eventzimmer.events SET starts_at = (SELECT CAST(now() + '1 month'::interval * random()  as timestamptz));"
}

sub_bootstrap(){
    echo "Running 'bootstrap' command."
    docker run -v $PWD/migrations:/migrations/ --network="container:$container_name" migrate/migrate -path=/migrations -database "postgresql://postgres:$pg_password@$container_name:5432/postgres?sslmode=disable" up 1 # initialise database
    docker exec -i -e PGPASSWORD=$pg_password $container_name psql --user postgres -h localhost -c "\copy eventzimmer.sources FROM /fixtures/sources.csv DELIMITER ',' CSV HEADER;" # insert sources
    docker exec -i -e PGPASSWORD=$pg_password $container_name psql --user postgres -h localhost -c "\copy eventzimmer.locations FROM fixtures/locations.csv DELIMITER ',' CSV HEADER;" # insert locations
    docker exec -i -e PGPASSWORD=$pg_password $container_name bash -c "psql --user postgres -h localhost < /fixtures/events.sql" # insert events
    docker run -v $PWD/migrations:/migrations/ --network="container:$container_name" migrate/migrate -path=/migrations -database "postgresql://postgres:$pg_password@$container_name:5432/postgres?sslmode=disable" up # add remaining migrations
}

sub_psql(){
    echo "Attaching to $container_name"
    docker exec -it -e PGPASSWORD=$pg_password $container_name psql --user postgres -h localhost
}

sub_migrate(){
    echo "Running 'migrate' command"
    docker run -v $PWD/migrations:/migrations/ --network="container:$container_name" migrate/migrate -path=/migrations -database "postgresql://postgres:$pg_password@$container_name:5432/postgres?sslmode=disable" "$@"
}
  
subcommand=$1
case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        sub_${subcommand} $@
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' is not a known subcommand." >&2
            echo "       Run '$program_name --help' for a list of known subcommands." >&2
            exit 1
        fi
        ;;
esac

