#!/usr/bin/with-contenv /bin/bash

set -e

echo "/srv/hazelcast.xml" >>/srv/templatable-config.txt

# Set defaults for unset vars
: ${HAZELCAST_SERVICE_DELAY_MIN:="${SERVICE_DELAY_DEFAULT_MIN}"}
: ${HAZELCAST_SERVICE_DELAY_STEP:="${SERVICE_DELAY_DEFAULT_STEP}"}
: ${HAZELCAST_SERVICE_DELAY_MAX:="${SERVICE_DELAY_DEFAULT_MAX}"}

: ${HAZELCAST_GROUP_NAME:="dotCMS"}
: ${HAZELCAST_SERVICE_NAMES:="hazelcast"}
: ${HAZELCAST_PORT:="5701"}

if [[ -n "${HAZELCAST_MANCENTER_URL}" ]]; then
    HAZELCAST_MANCENTER_ENABLED="true"
else
    HAZELCAST_MANCENTER_ENABLED="false"
fi
 
source /srv/container-utils/lib.inc

sleep ${HAZELCAST_SERVICE_DELAY_MIN}

count=$(( ${HAZELCAST_SERVICE_DELAY_MIN} + RANDOM % ${HAZELCAST_SERVICE_DELAY_MAX} ))
echo "Trying discovery for ~${count} seconds"
while [[ $count -ge ${HAZELCAST_SERVICE_DELAY_MIN} ]]; do

    [[ -n "${HAZELCAST_BIND_ADDR}" ]] || HAZELCAST_BIND_ADDR=$( getRouteAddrToService "${HAZELCAST_SERVICE_NAMES}" )

    hz_candidate_ip_list=$( getServiceIpAddresses "${HAZELCAST_SERVICE_NAMES}" $( getMyIpAddresses $( getMyNetworkInterfaces ) ) )
    hz_candidate_ips=()
    IFS=',' read -ra hz_candidate_ips <<< "${hz_candidate_ip_list}" && unset IFS

    if [[ ${#hz_candidate_ips[@]} -gt 0 ]]; then
        for hz_candidate_ip in "${hz_candidate_ips[@]}"; do

            hz_member_ips=($(wget --quiet -O - -T ${HAZELCAST_SERVICE_DELAY_STEP} ${hz_candidate_ip}:${HAZELCAST_PORT}/hazelcast/rest/cluster 2>/dev/null | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" || : ) )
            if [[ ${#hz_member_ips[@]} -lt 1 ]]; then
                echo "No members found from candidate ${hz_candidate_ip}";  
            else
                for hz_member_ip in "${hz_member_ips[@]}"; do
                    if [[ $(inArray "${hz_member_ip}" "${hz_members[@]}" ) == false ]]; then
                        echo "Found member ${hz_member_ip}"
                        hz_members+=(${hz_member_ip})
                    fi
                done
            fi
            sleep ${HAZELCAST_SERVICE_DELAY_STEP};
            (( count-=${HAZELCAST_SERVICE_DELAY_STEP} )) || :
        done
    else
        echo "No candidate members found, waiting ${HAZELCAST_SERVICE_DELAY_STEP} seconds..."
        sleep ${HAZELCAST_SERVICE_DELAY_STEP}
        (( count-=${HAZELCAST_SERVICE_DELAY_STEP} )) || :
    fi
done


# Bind address fallback
if [[ ! -n "${HAZELCAST_BIND_ADDR}" ]]; then
    echo "Service discovery failure, using localhost"
    HAZELCAST_BIND_ADDR="127.0.0.1"
fi

if [[  ${#hz_members[@]} -eq 0 ]]; then
    echo "No live members found, using self (${HAZELCAST_BIND_ADDR})"
    hz_members+=(${HAZELCAST_BIND_ADDR})
fi

echo "HAZELCAST_GROUP_NAME=${HAZELCAST_GROUP_NAME}" >> /srv/config.ini
echo "HAZELCAST_PORT=${HAZELCAST_PORT}" >> /srv/config.ini
echo "HAZELCAST_BIND_ADDR=${HAZELCAST_BIND_ADDR}" >> /srv/config.ini
echo "HAZELCAST_MANCENTER_ENABLED=${HAZELCAST_MANCENTER_ENABLED}" >> /srv/config.ini

echo "HAZELCAST_DISCOVERY_MEMBERS=$(join , ${hz_members[@]})" >> /srv/config.ini



