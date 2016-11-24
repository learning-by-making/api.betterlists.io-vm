#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $API_DB_USER WITH PASSWORD '$API_DB_PWD' CREATEDB;
    CREATE DATABASE $API_DB_USER;
    GRANT ALL PRIVILEGES ON DATABASE $API_DB_USER TO $API_DB_USER;
EOSQL