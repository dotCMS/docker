#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL


    CREATE USER dotcmsdbuser with PASSWORD 'password';
    CREATE DATABASE dotcms;
    GRANT ALL PRIVILEGES ON DATABASE dotcms TO dotcmsdbuser;

EOSQL