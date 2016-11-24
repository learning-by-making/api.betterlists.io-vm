#!/usr/bin/env bash

source .env
source .env.local
source api_db_conf/.env
source api_db_conf/.env.local

echo "DATABASE_URL='postgres://$API_DB_USER:$API_DB_PWD@$API_DB_CONTAINER_NAME/api_development'" >> $SOURCE_PATH/.env.development
echo "DATABASE_URL='postgres://$API_DB_USER:$API_DB_PWD@$API_DB_CONTAINER_NAME/api_test'" >> $SOURCE_PATH/.env.test