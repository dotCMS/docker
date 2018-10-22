#!/usr/bin/with-contenv /bin/bash

set -e

source /srv/docker-container/utils/config-defaults.sh


echo "CMS_CONNECTOR_THREADS=${CMS_CONNECTOR_THREADS}" >>/srv/docker-container/config/settings.ini
echo "CMS_SMTP_HOST=${CMS_SMTP_HOST}" >>/srv/docker-container/config/settings.ini