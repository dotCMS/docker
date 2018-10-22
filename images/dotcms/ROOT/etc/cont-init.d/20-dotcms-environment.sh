#!/usr/bin/with-contenv /bin/bash

set -e

source /srv/docker-container/utils/config-defaults.sh


# Default opts
JAVA_OPTS="-Djava.awt.headless=true -Xverify:none -Dfile.encoding=UTF8 -server -XX:+DisableExplicitGC"
# Memory opts
JAVA_OPTS="$JAVA_OPTS -XX:MaxMetaspaceSize=512m -Xms${CMS_HEAP_SIZE} -Xmx${CMS_HEAP_SIZE}"
# GC opts
JAVA_OPTS="$JAVA_OPTS -XX:+UseG1GC"
# Agent opts
JAVA_OPTS="$JAVA_OPTS -javaagent:${TOMCAT_HOME}/webapps/ROOT/WEB-INF/lib/byte-buddy-agent-1.6.12.jar"
# PDFbox cache location
JAVA_OPTS="$JAVA_OPTS -Dpdfbox.fontcache=/data/local/dotsecure"

# Finally, add user-provided JAVA_OPTS
JAVA_OPTS="$JAVA_OPTS ${CMS_JAVA_OPTS}"


# Setup Java environment to import into restricted runtime env
envvarlist=( "HOSTNAME" "LANG" "JAVA_HOME" "JAVA_OPTS")

mkdir -p /var/run/s6/env-dotcms

for varname in ${envvarlist[@]}; do
    echo "  ${varname}=${!varname}"
    echo -n "${!varname}" >"/var/run/s6/env-dotcms/${varname}"
done
