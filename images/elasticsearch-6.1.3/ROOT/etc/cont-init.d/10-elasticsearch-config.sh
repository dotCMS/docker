#!/usr/bin/with-contenv /bin/bash

set -e

# Set defaults for unset vars
: ${ELASTICSEARCH_SERVICE_DELAY_MIN:="${SERVICE_DELAY_DEFAULT_MIN}"}
: ${ELASTICSEARCH_SERVICE_DELAY_STEP:="${SERVICE_DELAY_DEFAULT_STEP}"}
: ${ELASTICSEARCH_SERVICE_DELAY_MAX:="${SERVICE_DELAY_DEFAULT_MAX}"}

: ${ELASTICSEARCH_CLUSTER_NAME:="dotCMSContentIndex"}
: ${ELASTICSEARCH_SERVICE_NAMES:="elasticsearch"}
: ${ELASTICSEARCH_PORT_TRANSPORT:="9300"}
: ${ELASTICSEARCH_PORT_HTTP:="9200"}
: ${ELASTICSEARCH_ADDR_HTTP:="localhost"}

: ${ELASTICSEARCH_NODE_MASTER:="true"}
: ${ELASTICSEARCH_NODE_DATA:="true"}

source /srv/container-utils/lib.inc

sleep ${ELASTICSEARCH_SERVICE_DELAY_MIN}

count=$(( ${ELASTICSEARCH_SERVICE_DELAY_MIN} + RANDOM % ${ELASTICSEARCH_SERVICE_DELAY_MAX} ))
echo "Trying discovery for ~${count} seconds"
while [[ $count -ge ${ELASTICSEARCH_SERVICE_DELAY_MIN} && ${#es_members[@]} -lt 1 ]]; do

    [[ -n "${ELASTICSEARCH_ADDR_TRANSPORT}" ]] || ELASTICSEARCH_ADDR_TRANSPORT=$( getRouteAddrToService "${ELASTICSEARCH_SERVICE_NAMES}" )

    es_candidate_ip_list=$(getServiceIpAddresses "${ELASTICSEARCH_SERVICE_NAMES}" $( getMyIpAddresses $( getMyNetworkInterfaces ) ) )
    es_candidate_ips=()
    IFS=',' read -ra es_candidate_ips <<< "${es_candidate_ip_list}" && unset IFS

    es_members=()
    if [[ ${#es_candidate_ips[@]} -gt 0 ]]; then
        echo "Testing server candidates: ${es_candidate_ip_list}..."
        for es_candidate_ip in "${es_candidate_ips[@]}"; do
            echo -n "  ${es_candidate_ip}: "
            if dockerize -wait "tcp://${es_candidate_ip}:${ELASTICSEARCH_PORT_TRANSPORT}" -timeout ${ELASTICSEARCH_SERVICE_DELAY_STEP}s true &> /dev/null; then
                [[ $(inArray "${es_member_ip}" "${es_members[@]}" ) == false ]] && es_members+=(${es_candidate_ip})
                echo "live"
                break 2
            else
                echo "not live"
            fi
            (( count-=${ELASTICSEARCH_SERVICE_DELAY_STEP} )) || :
        done
    else
        echo "No server candidates found, waiting ${ELASTICSEARCH_SERVICE_DELAY_STEP} seconds..."
        sleep ${ELASTICSEARCH_SERVICE_DELAY_STEP}
        (( count-=${ELASTICSEARCH_SERVICE_DELAY_STEP} )) || :
    fi
done


# Bind address fallback
if [[ ! -n "${ELASTICSEARCH_ADDR_TRANSPORT}" ]]; then
    echo "Service discovery failure, using localhost"
    ELASTICSEARCH_ADDR_TRANSPORT="127.0.0.1"
fi

[[ -e /srv/config/discovery-file/unicast_hosts.txt  ]] && rm /srv/config/discovery-file/unicast_hosts.txt 
touch /srv/config/discovery-file/unicast_hosts.txt 
    
if [[  ${#es_members[@]} -eq 0 ]]; then
    echo "No live members found, using self (${ELASTICSEARCH_ADDR_TRANSPORT})"
    es_members+=(${ELASTICSEARCH_ADDR_TRANSPORT})
elif [[  ${#es_members[@]} -gt 0 ]]; then
   echo "ES INITIAL DISCOVERY: ${#es_members[@]} members found."
    for es_member in "${es_members[@]}"; do
        echo -e "\n${es_member}:${ELASTICSEARCH_PORT_TRANSPORT}" >>/srv/config/discovery-file/unicast_hosts.txt
    done
    cat /srv/config/discovery-file/unicast_hosts.txt 
fi


export ELASTICSEARCH_CLUSTER_NAME
export ELASTICSEARCH_PORT_TRANSPORT
export ELASTICSEARCH_PORT_HTTP
export ELASTICSEARCH_ADDR_TRANSPORT
export ELASTICSEARCH_ADDR_HTTP

export ELASTICSEARCH_NODE_MASTER
export ELASTICSEARCH_NODE_DATA

dockerize -template /srv/config/elasticsearch.yml:/srv/config/elasticsearch.yml
