DEPLOYMENT
----------

Below is a guide to install `schema` under a fresh Ubuntu.

1. [Install Docker](https://docs.docker.com/compose/install/)
2. Clone schema to `/usr/local/schema` (`git clone https://github.com/eventzimmer/schema.git /usr/local/schema`)
3. Create the web network: `docker network create web`
4. Create a user and add it to the `docker` group
5. Bootstrap system service (`mkdir -p ~/.config/systemd/user/` and `cp /usr/system/schema/systemd/schema.service ~/.config/systemd/user/`)
6. Bootstrap `traefik` and `PostgreSQL` data directories (`mkdir -p ~/.data/traefik` and `mkdir -p ~/.data/postgres`)
7. Enable auto-start and lingering for the user (`sudo loginctl enable-linger user`)
8. Add a SSH key (or other way to authenticate to that user) to the user
9. Log in to the user and enable the service (`systemctl --user enable schema`)

The user (e.g `marietta`) can then use `systemctl --user start schema` and all of the `systemctl` and `journalctl` tools to work with the schema command.

## Migrations

- `docker inspect --format '{{ .NetworkSettings.IPAddress }}' schema_db`
- `docker run --network host migrate/migrate -db potgres://user@IP`

## Cleaning up

- `docker kill $(docker ps -q)`
- `docker system prune`
