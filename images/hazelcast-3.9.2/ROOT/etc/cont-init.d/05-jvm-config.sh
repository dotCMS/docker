#!/usr/bin/with-contenv /bin/bash

set -e

echo "/srv/server.sh" >>/srv/templatable-config.txt


: ${HAZELCAST_HEAP_MIN:="128m"}
: ${HAZELCAST_HEAP_MAX:="1024m"}

echo "HAZELCAST_HEAP_MIN=${HAZELCAST_HEAP_MIN}" >> /srv/config.ini
echo "HAZELCAST_HEAP_MAX=${HAZELCAST_HEAP_MAX}" >> /srv/config.ini

