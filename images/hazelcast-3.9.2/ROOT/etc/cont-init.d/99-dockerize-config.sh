#!/usr/bin/with-contenv /bin/bash

set -e

for template in $( cat /srv/templatable-config.txt |sort -u ); do
    template=$( eval echo "${template}" )
    echo "Adding template \"${template}\""
    export DOCKERIZE_TEMPLATES="${DOCKERIZE_TEMPLATES} -template ${template}:${template}"
done

if [[ -e /srv/config.ini ]]; then
    for val in $(cat /srv/config.ini); do
        export ${val}
    done
fi

echo "Applying config:"
cat /srv/config.ini

rm /srv/config.ini

dockerize ${DOCKERIZE_TEMPLATES}