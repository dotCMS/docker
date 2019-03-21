#!/usr/bin/with-contenv /bin/bash

set -e

source /srv/docker-container/utils/config-defaults.sh

existing_group=$(grep -oP "\K[[:alnum:]]+(?=\:x\:${CMS_RUNAS_GID}\:.*$)" /etc/group || true) 

if [[ -z "$existing_group" ]]; then
    addgroup -S -g $CMS_RUNAS_GID dotcms
elif [[ "$existing_group" != "root" ]]; then
    echo "ERROR: GID $CMS_RUNAS_GID already exists as '$existing_group'. Quitting!"
    exit 1
else
    echo "WARNING: Will run dotCMS as 'root' group!"
fi

existing_user=$(grep -oP "\K[[:alnum:]]+(?=\:x\:${CMS_RUNAS_UID}\:.*$)" /etc/passwd || true)

if [[ -z "$existing_user" ]]; then
    adduser -S -H -h /srv/home -s /bin/false -G dotcms -u $CMS_RUNAS_UID -g dotCMS dotcms
elif [[ "$existing_user" != "root" ]]; then
    echo "ERROR: UID $CMS_RUNAS_UID already exists as '$existing_user'. Quitting!"
    exit 1
else
    echo "WARNING: Will run dotCMS as 'root' user!"
fi


