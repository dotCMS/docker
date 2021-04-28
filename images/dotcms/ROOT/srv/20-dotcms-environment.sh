#!/bin/bash

set -e

source /srv/utils/config-defaults.sh

case "$TOMCAT_VERSION}" in
  '8.5.32' )
    BYTE_BUDDY_VERSION='1.6.12'
    ;;
  *)
    BYTE_BUDDY_VERSION='1.9.0'
    ;;
esac

echo "dotCMS environment ...."
# Default opts
JAVA_OPTS="-Djava.awt.headless=true -Xverify:none -Dfile.encoding=UTF8 -server -XX:+DisableExplicitGC"
# Memory opts
JAVA_OPTS="$JAVA_OPTS -XX:MaxMetaspaceSize=512m -Xms${CMS_HEAP_SIZE} -Xmx${CMS_HEAP_SIZE}"
# GC opts
JAVA_OPTS="$JAVA_OPTS -XX:+UseG1GC"
# Agent opts
JAVA_OPTS="$JAVA_OPTS -javaagent:${TOMCAT_HOME}/webapps/ROOT/WEB-INF/lib/byte-buddy-agent-${BYTE_BUDDY_VERSION}.jar"
# PDFbox cache location
JAVA_OPTS="$JAVA_OPTS -Dpdfbox.fontcache=/data/local/dotsecure"

# Finally, add user-provided JAVA_OPTS
JAVA_OPTS="$JAVA_OPTS ${CMS_JAVA_OPTS}"

echo "HOSTNAME=${HOSTNAME}" >>/srv/config/settings.ini
echo "LANG=${LANG}" >>/srv/config/settings.ini
echo "JAVA_HOME=${JAVA_HOME}" >>/srv/config/settings.ini
echo "JAVA_OPTS=${JAVA_OPTS}" >>/srv/config/settings.ini
