#!/bin/bash

set -e

RUNAS_UID=$(grep -oP "dotcms\:x\:\K[[:digit:]]+(?=\:.*$)" /etc/passwd || true)
[[ -z "$RUNAS_UID" ]] && RUNAS_UID=0

RUNAS_GID=$(grep -oP "dotcms\:x\:\K[[:digit:]]+(?=\:.*$)" /etc/group || true)
[[ -z "$RUNAS_GID" ]] && RUNAS_GID=0


if [[ "${1}" == "dotcms" || -z "${1}" ]]; then

    echo "Starting dotCMS as UID:GID $RUNAS_UID:$RUNAS_GID..."

    [[ -f /srv/TOMCAT_VERSION ]] && TOMCAT_VERSION=$( cat /srv/TOMCAT_VERSION )
    TOMCAT_HOME=/srv/dotserver/tomcat-${TOMCAT_VERSION}

    export CATALINA_PID="/tmp/dotcms.pid"
    if [ -e "$CATALINA_PID" ]; then
            echo
            echo "Pid file $CATALINA_PID exists! Are you sure dotCMS is not running?"
            echo
            exit 1
    fi

    cd /srv/home

    DB_CONNECT_TEST="$(cat /srv/DB_CONNECT_TEST | tr -d [:space:])"
    if [[ -n "$DB_CONNECT_TEST" ]]; then
        /bin/exec -c -- \
        /bin/s6-envdir -fn -- /var/run/s6/env-dotcms \
        /bin/exec -- \
        /usr/local/bin/dockerize -wait tcp://${DB_CONNECT_TEST} -timeout 60s \
         /bin/s6-setuidgid $RUNAS_UID:$RUNAS_GID  ${TOMCAT_HOME}/bin/catalina.sh run
    else
        /bin/exec -c -- \
        /bin/s6-envdir -fn -- /var/run/s6/env-dotcms \
        /bin/exec -- \
        /usr/local/bin/dockerize \
         /bin/s6-setuidgid $RUNAS_UID:$RUNAS_GID  ${TOMCAT_HOME}/bin/catalina.sh run
    fi

else

    echo "Running user CMD..."
    exec -- "$@"
fi