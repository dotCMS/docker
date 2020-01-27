#!/bin/bash

set -e

source /srv/utils/config-defaults.sh

echo "Elasticsearch Config ...."
if [[ -z "${PROVIDER_ELASTICSEARCH_DNSNAMES}" ]]; then

    echo "PROVIDER_ELASTICSEARCH_DNSNAMES=" >>/srv/config/settings.ini
    echo "PROVIDER_ELASTICSEARCH_CLUSTER_NAME=${PROVIDER_ELASTICSEARCH_CLUSTER_NAME}" >>/srv/config/settings.ini
    echo "PROVIDER_ELASTICSEARCH_ADDR_TRANSPORT=127.0.0.1" >>/srv/config/settings.ini
    echo "PROVIDER_ELASTICSEARCH_PORT_TRANSPORT=${PROVIDER_ELASTICSEARCH_PORT_TRANSPORT}" >>/srv/config/settings.ini
    echo "PROVIDER_ELASTICSEARCH_ADDR_HTTP=${PROVIDER_ELASTICSEARCH_ADDR_HTTP}" >>/srv/config/settings.ini
    echo "PROVIDER_ELASTICSEARCH_PORT_HTTP=${PROVIDER_ELASTICSEARCH_PORT_HTTP}" >>/srv/config/settings.ini
    echo "PROVIDER_ELASTICSEARCH_ENABLE_HTTP=${PROVIDER_ELASTICSEARCH_ENABLE_HTTP}" >>/srv/config/settings.ini
    echo "Elasticsearch configuration set"
fi
