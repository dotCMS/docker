#!/usr/bin/with-contenv /bin/bash

set -e

source /srv/container-utils/config-defaults.sh

echo "/srv/server.sh" >>/srv/templatable-config.txt

echo "MIN_HEAP_SIZE=${PROVIDER_HAZELCAST_HEAP_MIN}" >> /srv/config.ini
echo "MAX_HEAP_SIZE=${PROVIDER_HAZELCAST_HEAP_MAX}" >> /srv/config.ini

