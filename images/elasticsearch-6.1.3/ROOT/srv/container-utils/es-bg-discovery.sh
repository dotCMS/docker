#!/usr/bin/with-contenv /bin/bash

set -e

# Set defaults for unset vars
: ${ELASTICSEARCH_SERVICE_REFRESH:='10'}
: ${ELASTICSEARCH_SERVICE_DELAY_STEP:="${SERVICE_DELAY_DEFAULT_STEP}"}
: ${ELASTICSEARCH_SERVICE_NAMES:="elasticsearch"}
: ${ELASTICSEARCH_PORT_TRANSPORT:="9300"}

source /srv/container-utils/lib.inc

sleep $ELASTICSEARCH_SERVICE_REFRESH
export ELASTICSEARCH_PORT_TRANSPORT

while [[ ! -f /srv/run/pid ]]; do
    echo "Elasticsearch background discovery: pidfile not found, waiting ${ELASTICSEARCH_SERVICE_REFRESH} seconds..."
    sleep ${ELASTICSEARCH_SERVICE_REFRESH}
done

# Loop as long as Elasticsearch is running
while kill -s 0 $(cat /srv/run/pid) 2>/dev/null; do


    es_candidate_ip_list=$(getServiceIpAddresses "${ELASTICSEARCH_SERVICE_NAMES}" $( getMyIpAddresses $( getMyNetworkInterfaces ) ) )
    es_candidate_ips=()
    IFS=',' read -ra es_candidate_ips <<< "${es_candidate_ip_list}" && unset IFS

    es_members=()
    if [[ ${#es_candidate_ips[@]} -gt 0 ]]; then
        for es_candidate_ip in "${es_candidate_ips[@]}"; do
            if dockerize -wait "tcp://${es_candidate_ip}:${ELASTICSEARCH_PORT_TRANSPORT}" -timeout ${ELASTICSEARCH_SERVICE_DELAY_STEP}s true &> /dev/null; then
                [[ $(inArray "${es_member_ip}" "${es_members[@]}" ) == false ]] && es_members+=(${es_candidate_ip})
            fi
            (( count-=${ELASTICSEARCH_SERVICE_DELAY_STEP} )) || :
        done
    fi

    [[ -e /srv/config/discovery-file/unicast_hosts.txt.new ]] && rm /srv/config/discovery-file/unicast_hosts.txt.new
    touch /srv/config/discovery-file/unicast_hosts.txt.new
    for es_member in "${es_members[@]}"; do
        echo "${es_member}:${ELASTICSEARCH_PORT_TRANSPORT}" >>/srv/config/discovery-file/unicast_hosts.txt.new
    done

    hash_orig=$(cat /srv/config/discovery-file/unicast_hosts.txt |sort -u |md5sum |cut -f 1 -d ' ')
    hash_new=$(cat /srv/config/discovery-file/unicast_hosts.txt.new |sort -u |md5sum |cut -f 1 -d ' ')

    if [[ "${hash_orig}" != "${hash_new}" ]]; then
        echo "ES DISCOVERY MEMBERS CHANGED: ${#es_members[@]} members"
        cat /srv/config/discovery-file/unicast_hosts.txt.new
        mv /srv/config/discovery-file/unicast_hosts.txt.new /srv/config/discovery-file/unicast_hosts.txt
    fi

    sleep ${ELASTICSEARCH_SERVICE_REFRESH}
    
done

echo "ERROR: Elasticsearch pid not found!! Quitting"
s6-svscanctl -t /var/run/s6/services