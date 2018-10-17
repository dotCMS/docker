#!/usr/bin/with-contenv /bin/bash

set -e

: ${ELASTICSEARCH_HEAP_SIZE:="1024m"}

export ELASTICSEARCH_HEAP_SIZE

dockerize -template /srv/config/jvm.options:/srv/config/jvm.options
