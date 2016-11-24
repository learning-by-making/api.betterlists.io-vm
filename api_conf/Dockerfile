FROM ruby:2.3.2
MAINTAINER piccio@betterlists.io

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev
# for 'hanami db [COMMAND]'
RUN apt-get install -y postgresql-client

ARG USER
ENV USER ${USER:-api}
RUN useradd $USER
USER $USER

ARG API_PATH
ENV API_PATH ${API_PATH:-/api_default}

WORKDIR $API_PATH
