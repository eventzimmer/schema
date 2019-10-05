# Setting up the eventzimmer API

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

## Setting up authentication

If you'd like to be able to insert data into `schema`, you will need to have privileges beyond the `web_anon` role. These privileges are granted from `PostgREST` using [JWT](http://jwt.io).

The interna of this mechanism are described [in their documentation](http://postgrest.org/en/v6.0/tutorials/tut1.html).

There are many available platforms to generate `JWT` tokens. As for simplicity of the project, we have chosen [Auth0](https://auth0.com).

This guide will give an introduction about how to get `schema` running with `Auth0`. It may work with other `JWT` platforms, but no guarantees are given.

1. Register an account at [Auth0](https://auth0.com)
2. Set up an API. [Create API image](./docs/create_api.png) (remember the identifier, because it corresponds to the `PGRST_JWT_AUD` variable).
3. This automatically creates an `machine-to-machine` application. [The credentials](./docs/credentials.png) will be important for the `aggregator`.

### Obtaining the signing key  

In your newly created `machine-to-machine` application, under `Settings -> Advanced Settings -> Endpoints` you will find a `JSON Web Key Set` ([JWKS](./jwks.png)).

Open this URL in your browser, it will contain a `JSON Web Key Set`, which may, pretty-printed, look something like this:

```
{
	"keys": [{
		"alg": "RS256",
		"kty": "RSA",
		"use": "sig",
		"x5c": ["MIIDDTCCAfWgAwIBAgIJK1/ihDnxhzv6MA0GCSqGSIb3DQEBCwUAMCQxIjAgBgNVBAMTGWRldi1yeHc5ZWc1dy5ldS5hdXRoMC5jb20wHhcNMTkwOTI2MjA0MzM4WhcNMzMwNjA0MjA0MzM4WjAkMSIwIAYDVQQDExlkZXYtcnh3OWVnNXcuZXUuYXV0aDAuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtueI+9ggZ01Y/LbLpA5wo95FfKBLLYjc2yvsOw0TNLdYCsAIJQjM2Xok/ZkAEyeIADfiZwvu04d/XDj5HrC8AoKD1jWGWgn+8VXi3gyxJDeAX4bXNAsscgNuTg1tarlKLEx0JORDCvAf3lYAXGH8wBmhjdNBCzZFhnmdcR7xW20hf/k5rJZVuF5aHyrs1KXYrZwjqm4BN+KKmD82+1MQ3AR8lKnFCcCl2iY5vItf4Pm8onMD1xnI4SGeKfYPhjvy1s1rthW0isvkgJEwELFhbABNb00xV697N8qlF7/uSvPVLdYsPuLT8m2IaNjZHpLgXhVT5dYwzbL41k6yN0V90QIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQSTZKbC9MHNXMnKVJjCc+DJ1LB+TAOBgNVHQ8BAf8EBAMCAoQwDQYJKoZIhvcNAQELBQADggEBAHU3e2uGhql7OtdWggPcjmLWVcuA/QBRIgTh59zmiRU5ihA1RnhNT38gz0Q/fK2l9uzCCVsftKbImOriJ/QzcY7oDsaY+jmHgFF/HUiRW596gpiU/NndyAmaLJyVGOWJtYeQKRmR8JDlipXG8kCfOzoA6Op9ZvuunrSxHs8LOywvm9VqDoGVF7PBbdly1Qu1hci1Ac2xLki2RFh7MFANiKmrRNviXcFjVqwlnA/O27hBnGZGQ22i9pD2kgZON55CNV1DBQKQtrjUFe3zyq0CGQE63lHuN2f/q+wa8jyZPlSOPNLtJmuI8Z23MWJk38teNm8UvLNs5yEsTHBRgPfJrSk="],
		"n": "tueI-9ggZ01Y_LbLpA5wo95FfKBLLYjc2yvsOw0TNLdYCsAIJQjM2Xok_ZkAEyeIADfiZwvu04d_XDj5HrC8AoKD1jWGWgn-8VXi3gyxJDeAX4bXNAsscgNuTg1tarlKLEx0JORDCvAf3lYAXGH8wBmhjdNBCzZFhnmdcR7xW20hf_k5rJZVuF5aHyrs1KXYrZwjqm4BN-KKmD82-1MQ3AR8lKnFCcCl2iY5vItf4Pm8onMD1xnI4SGeKfYPhjvy1s1rthW0isvkgJEwELFhbABNb00xV697N8qlF7_uSvPVLdYsPuLT8m2IaNjZHpLgXhVT5dYwzbL41k6yN0V90Q",
		"e": "AQAB",
		"kid": "NkZCMDNBNjYxM0FBNjhCNzU1RDcxMzFEMUFGRjI4QzEzNDBDREFGNQ",
		"x5t": "NkZCMDNBNjYxM0FBNjhCNzU1RDcxMzFEMUFGRjI4QzEzNDBDREFGNQ"
	}]
}
```

We will extract the key including only the following properties:

- `alg`
- `kty`
- `use`
- `n`
- `kid`
- `e`

This behaviour is further documented in [the PostgREST documentation](https://github.com/PostgREST/postgrest-docs/blob/master/auth.rst).

Extracting from above sample, it would be:
```
{
	"alg": "RS256",
	"kty": "RSA",
	"use": "sig",
	"n": "tueI-9ggZ01Y_LbLpA5wo95FfKBLLYjc2yvsOw0TNLdYCsAIJQjM2Xok_ZkAEyeIADfiZwvu04d_XDj5HrC8AoKD1jWGWgn-8VXi3gyxJDeAX4bXNAsscgNuTg1tarlKLEx0JORDCvAf3lYAXGH8wBmhjdNBCzZFhnmdcR7xW20hf_k5rJZVuF5aHyrs1KXYrZwjqm4BN-KKmD82-1MQ3AR8lKnFCcCl2iY5vItf4Pm8onMD1xnI4SGeKfYPhjvy1s1rthW0isvkgJEwELFhbABNb00xV697N8qlF7_uSvPVLdYsPuLT8m2IaNjZHpLgXhVT5dYwzbL41k6yN0V90Q",
	"e": "AQAB",
	"kid": "NkZCMDNBNjYxM0FBNjhCNzU1RDcxMzFEMUFGRjI4QzEzNDBDREFGNQ"
}
```

This key will be passed as the `PGRST_JWT_SECRET` environment variable. You can use e.g `JSON.stringify` to make this an escaped string:

```
a = {
	...
}
JSON.stringify(a)
```

### Hold tight, the role is missing

We told `schema` that it will receive tokens from our `Auth0` account. However the default keys will not include a `role` claim, essentially telling `PostgREST` which `role` to use for this token.
We can fix this by adding a `Hook` in `Auth0`.

In the main menu, create a new hook under `Client Credentials Exchange`, and paste the following code:

```
/**
@param {object} client - information about the client
@param {string} client.name - name of client
@param {string} client.id - client id
@param {string} client.tenant - Auth0 tenant name
@param {object} client.metadata - client metadata
@param {array|undefined} scope - array of strings representing the scope claim or undefined
@param {string} audience - token's audience claim
@param {object} context - additional authorization context
@param {object} context.webtask - webtask context
@param {function} cb - function (error, accessTokenClaims)
*/
module.exports = function(client, scope, audience, context, cb) {
  var access_token = {};
  access_token['https://eventzimmer.de/role'] = 'aggregator';

  cb(null, access_token);
};
```

That's it. You're set in stone. Every new request signed will now tell `schema` to use the `aggregator` role (essentially the `PGRST_ROLE_CLAIM_KEY` environment variable).
