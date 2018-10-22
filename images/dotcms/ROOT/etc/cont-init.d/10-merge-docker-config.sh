#!/usr/bin/with-contenv /bin/bash

set -e

source /srv/docker-container/utils/discovery-include.sh
source /srv/docker-container/utils/config-defaults.sh


# Overwrite Tomcat files
cd /srv/docker-container/templates/tomcat/OVERRIDE
for OVERRIDEFILE in $(find . -type f); do
    [[ ! -d "${TOMCAT_HOME}/$(dirname $OVERRIDEFILE)" ]] && mkdir -p "${TOMCAT_HOME}/$(dirname $OVERRIDEFILE)"
    cp "$OVERRIDEFILE" "${TOMCAT_HOME}/$OVERRIDEFILE"
    
    # TODO: Hazelcast session store
    #[[ "$(basename $file)" == "hazelcast-client.xml" ]] && cp $file /srv/bin/system/src-conf/

    # feed to Dockerize for templating
    echo "${TOMCAT_HOME}/$OVERRIDEFILE" >>/srv/docker-container/config/templatable.txt

done

# Overwrite dotCMS app files
cd /srv/docker-container/templates/dotcms/OVERRIDE
for OVERRIDEFILE in $(find . -type f); do
    echo $OVERRIDEFILE
    [[ ! -d "${TOMCAT_HOME}/webapps/ROOT/$(dirname $OVERRIDEFILE)" ]] && mkdir -p "${TOMCAT_HOME}/webapps/ROOT/$(dirname $OVERRIDEFILE)"

    if [[ "$OVERRIDEFILE" == "hazelcast-client.xml" ]]; then
        cp "$OVERRIDEFILE" /srv/bin/system/src-conf/hazelcast-client.xml
        echo "/srv/bin/system/src-conf/hazelcast-client.xml" >>/srv/container-config/templatable.txt
    fi

    cp "$OVERRIDEFILE" "${TOMCAT_HOME}/webapps/ROOT/$OVERRIDEFILE"

    # feed to Dockerize for templating
    echo "${TOMCAT_HOME}/webapps/ROOT/$OVERRIDEFILE" >>/srv/docker-container/config/templatable.txt

done


# Merge dotCMS properties diffs
cd /srv/docker-container/templates/dotcms/CONF
for MERGEFILE in $(find . -type f); do
    echo "Merging $MERGEFILE"
    RUNFILE="${TOMCAT_HOME}/webapps/ROOT/WEB-INF/classes/$(basename $MERGEFILE)"
    SRCFILE="/srv/bin/system/src-conf/$(basename $MERGEFILE)"

    for varname in $(grep -oP "^\K[[:alnum:]].*(?=\=)" "$MERGEFILE"); do
        escaped_varname=$(escapeRegexChars "$varname")
        echo "Resetting '$varname'"
        sed -ri "s/^(${escaped_varname})\s*=(.*)$/#\1=\2/" "$RUNFILE"
        sed -ri "s/^(${escaped_varname})\s*=(.*)$/#\1=\2/" "$SRCFILE"
    done

    config_injection=$(<"$MERGEFILE")

    prefile=$(sed '/##\ BEGIN\ PLUGINS/Q' "$RUNFILE")
    postfile=$(sed -ne '/##\ BEGIN\ PLUGINS/,$ p' "$RUNFILE")
    echo -e "${prefile}\n${config_injection}\n\n\n${postfile}" >"$RUNFILE"

    prefile=$(sed '/##\ BEGIN\ PLUGINS/Q' "$SRCFILE")
    postfile=$(sed -ne '/##\ BEGIN\ PLUGINS/,$ p' "$SRCFILE")
    echo -e "${prefile}\n${config_injection}\n\n\n${postfile}" >"$SRCFILE"

    # feed to Dockerize for templating
    echo "$RUNFILE" >>/srv/docker-container/config/templatable.txt

done


