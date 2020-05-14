#!/bin/bash

set -e

source /srv/utils/config-defaults.sh


echo "Database config ...."
if [[ -z "${PROVIDER_DB_DNSNAME}" ]]; then
  PROVIDER_DB_DRIVER="H2"
else
  PROVIDER_DB_DRIVER=$(echo $PROVIDER_DB_DRIVER | tr '[:lower:]' '[:upper:]')
fi

case "$PROVIDER_DB_DRIVER" in 

    H2)
        : ${PROVIDER_DB_DBNAME:="h2_dotcms_data"}
        ;;

    POSTGRES)
        : ${PROVIDER_DB_DBNAME:="dotcms"}
        [[ -z "$PROVIDER_DB_USERNAME" ]] && $PROVIDER_DB_USERNAME="postgres"
        [[ -z "PROVIDER_DB_PASSWORD" ]] && PROVIDER_DB_PASSWORD="postgres"
        [[ -z "$PROVIDER_DB_PORT" ]] && PROVIDER_DB_PORT="15432"
        ;;

    MYSQL)
        : ${PROVIDER_DB_DBNAME:="dotcms"}
        [[ -z "$PROVIDER_DB_USERNAME" ]] && $PROVIDER_DB_USERNAME="mysql"
        [[ -z "PROVIDER_DB_PASSWORD" ]] && PROVIDER_DB_PASSWORD="mysql"
        [[ -z "$PROVIDER_DB_PORT" ]] && PROVIDER_DB_PORT="13306"
        ;;

    ORACLE)
        : ${PROVIDER_DB_DBNAME:="XE"}
        [[ -z "$PROVIDER_DB_USERNAME" ]] && $PROVIDER_DB_USERNAME="oracle"
        [[ -z "PROVIDER_DB_PASSWORD" ]] && PROVIDER_DB_PASSWORD="oracle"
        [[ -z "$PROVIDER_DB_PORT" ]] && PROVIDER_DB_PORT="11521"
        ;;

    MSSQL)
        : ${PROVIDER_DB_DBNAME:="dotcms"}
        [[ -z "$PROVIDER_DB_USERNAME" ]] && $PROVIDER_DB_USERNAME="sa"
        [[ -z "PROVIDER_DB_PASSWORD" ]] && PROVIDER_DB_PASSWORD="dotCMS12345"
        [[ -z "$PROVIDER_DB_PORT" ]] && PROVIDER_DB_PORT="11433"
        ;;

    *)
        echo "Invalid DB driver specified!!"
        exit 1

esac


touch /tmp/DB_CONNECT_TEST
[[ "$PROVIDER_DB_DRIVER" != "H2" ]] && echo "${PROVIDER_DB_DNSNAME}:${PROVIDER_DB_PORT}" >/tmp/DB_CONNECT_TEST


echo "PROVIDER_DB_DRIVER=${PROVIDER_DB_DRIVER}" >>/srv/config/settings.ini
[[ -n "$PROVIDER_DB_URL" ]] && echo "PROVIDER_DB_URL=${PROVIDER_DB_URL}" >>/srv/config/settings.ini
echo "PROVIDER_DB_DBNAME=${PROVIDER_DB_DBNAME}" >>/srv/config/settings.ini
echo "PROVIDER_DB_DNSNAME=${PROVIDER_DB_DNSNAME}" >>/srv/config/settings.ini
echo "PROVIDER_DB_PORT=${PROVIDER_DB_PORT}" >>/srv/config/settings.ini
echo "PROVIDER_DB_USERNAME=${PROVIDER_DB_USERNAME}" >>/srv/config/settings.ini
echo "PROVIDER_DB_PASSWORD=${PROVIDER_DB_PASSWORD}" >>/srv/config/settings.ini
echo "PROVIDER_DB_MAXCONNS=${PROVIDER_DB_MAXCONNS}" >>/srv/config/settings.ini




