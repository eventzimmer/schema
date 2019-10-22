#!/bin/sh

program_name=$(basename $0)
pg_password="${PGPASSWORD:-mysecretpassword}"
container_name="${CONTAINER_NAME:-schema_db_1}"
  
sub_help(){
    echo "Usage: $program_name <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    bootstrap   Bootstraps a new database with fixtures and migrations"
    echo "    psql        Attaches a psql REPL to the database"
    echo "    migrate     Runs a migrate instance against the database"
    echo ""
    echo "For help with each subcommand run:"
    echo "$program_name <subcommand> -h|--help"
    echo ""
}

sub_bootstrap(){
    echo "Running 'bootstrap' command."
}

sub_psql(){
    echo "Attaching to $container_name"
    docker exec -it -e PGPASSWORD=$pg_password $container_name psql --user postgres -h localhost
}

sub_migrate(){
    echo "Running 'migrate' command."
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
