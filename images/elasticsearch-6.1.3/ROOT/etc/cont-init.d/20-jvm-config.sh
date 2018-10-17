#!/usr/bin/with-contenv /bin/bash

set -e

source /srv/container-utils/config-defaults.sh

export PROVIDER_ELASTICSEARCH_HEAP_SIZE

dockerize -template /srv/config/jvm.options:/srv/config/jvm.options
