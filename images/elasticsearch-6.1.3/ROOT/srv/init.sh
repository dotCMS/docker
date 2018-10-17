#!/bin/bash

set -e

if [[ "$1" == "elasticsearch" || -z "$1" ]]; then

    echo "Starting Elasticsearch server..."
    touch /srv/INIT_STARTED_ELASTICSEARCH

    cd /srv && mkdir run && chown elasticsearch:elasticsearch run
    gosu elasticsearch:elasticsearch \
        /bin/sh -c 'echo $$ >/srv/run/pid; exec elasticsearch'

elif [[ "$1" == "showconfig" ]]; then

    echo "File jvm.options:"
    cat /srv/config/jvm.options

    echo "File elasticsearch.yml:"
    cat /srv/config/elasticsearch.yml

    echo "File unicast_hosts.txt:"
    cat /srv/config/discovery-file/unicast_hosts.txt

else

    echo "Running user CMD..."
    exec -- "$@"

fi
