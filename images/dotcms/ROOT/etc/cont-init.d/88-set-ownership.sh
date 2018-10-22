#!/usr/bin/with-contenv /bin/bash

set -e

source /srv/docker-container/utils/config-defaults.sh

if [[ "${CMS_RUNAS_UID}:${CMS_RUNAS_GID}" == "0:0" ]]; then
    echo "Set to run as root (0:0), skipping ownership grant"
    exit 0
fi


echo "Setting file ownership for runtime user/group: $CMS_RUNAS_UID/$CMS_RUNAS_GID"

chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID "${TOMCAT_HOME}/webapps/ROOT/WEB-INF/H2_DATABASE"
chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID "${TOMCAT_HOME}/conf/Catalina"
chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID "${TOMCAT_HOME}/temp"
chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID "${TOMCAT_HOME}/logs"
chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID "${TOMCAT_HOME}/work"
chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID "${TOMCAT_HOME}/webapps/ROOT/WEB-INF"

chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID /data/local/esdata
chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID /data/local/dotsecure
chown -R $CMS_RUNAS_UID:$CMS_RUNAS_GID /data/local/felix

# Touch all of app filesystem for overlayfs copy_up issue after chown
echo "Refreshing overlayfs cache"
find "${TOMCAT_HOME}" -exec ls {} \; >/dev/null
find "/data/local" -exec ls {} \; >/dev/null