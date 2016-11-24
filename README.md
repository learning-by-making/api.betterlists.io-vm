# betterlists.box

Local development environment to the 
[api.betterlists.io](https://github.com/learning-by-making/api.betterlists.io) project

## Requirements

* Git
* Docker
* Docker Compose

## Setup

Clone `betterlists.box` repo and enter in its folder   
```bash
git clone git@github.com:learning-by-making/betterlists.box.git betterlists
cd betterlists
```

Clone `api.betterlists.io` repo
```bash
git clone git@github.com:learning-by-making/betterlists.io.git <api_local_source_path>
```

Set api service's `.env.development` and `.env.test` files with environment variables
```bash
./set_api_env.sh
```

Start api service
```bash
docker compose up -d api
```

On your local host you can:
* point your browser at `localhost:<web_host_port>`
* edit api project's files in `<api_local_source_path>` folder and manage them with git
* connect to postgres `docker-compose run --rm api_db psql -h <api_db_container_name> -U postgres_user or api_db_user>`

## Environment variables

### compose
 
variable | default value | description
---------|---------------|-------------
API_CONTAINER_NAME | betterlists_api | `api` container name
SOURCE_PATH | ./api | local folder containing the source api project, path is relative to docker-compose.yml
API_PATH | /api | container folder where the `SOURCE_PATH` local folder is mounted to
API_CONF_PATH | /api_conf | container folder where the local api configuration folder is mounted to 
WEB_HOST_PORT | 3000 | local port where the `api` web server port is mapped to
WEB_GUEST_PORT | 9292 | container port where the `api` web server is listening to
BUNDLE_PATH | /bundle | container folder where gem files are stored, it is mounted to local folder to cache gems (http://bradgessler.com/articles/docker-bundler/)
API_DB_CONTAINER_NAME | betterlists_api_db | `api_db` container name
POSTGRES_VERSION | 9.6.1 | version of the postgres image used in the `api_db` container
API_DB_HOST_PORT | 5432 | local port where the `api_db` database server port is mapped to

### api_db service

variable | default value | description
---------|---------------|-------------
POSTGRES_USER | postgres | superuser for PostgreSQL
POSTGRES_PASSWORD | secret | superuser password for PostgreSQL
API_DB_USER | betterlists | database user for the `api` service, used in api_db_conf/init-user-db.sh
API_DB_PWD | secret | `API_DB_USER` password, used in `api_db_conf/init-user-db.sh`

More info: https://hub.docker.com/_/postgres/

### Override

Docker Compose can read 
[environment variables only from a .env file](https://docs.docker.com/compose/environment-variables/#/the-env-file) 
in its same folder.
If you want to override Docker Compose environment variables set them on the current shell.
(you can edit their values on a `.env.local` file and load it on the current shell with
`source .env.local`)

To override `api_db` service environment variables edit `api_db_conf/env.local` file 
that is passed to the `api_db` container by `docker-compose.override.yml`.

More info on extending/overriding docker-compose: https://docs.docker.com/compose/extends

## Api start-up

Some little tips to start-up the api project.
* docker-compose run --rm -e HANAMI_VERSION=0.9.0 api bundle init --gemspec=../api_conf/.gemspec_template
* docker-compose run --rm --user="$(id -u):$(id -g)" api bundle install
* docker-compose run --rm --user="$(id -u):$(id -g)" api bundle exec hanami new . --application_name=api --db=postgresql --test=rspec
