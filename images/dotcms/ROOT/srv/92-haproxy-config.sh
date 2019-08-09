#!/bin/bash

set -e

source /srv/utils/discovery-include.sh
source /srv/utils/config-defaults.sh

echo "Haproxy config ...."

if [[ -z "${CMS_DNSNAMES}" ]]; then

    echo "Haproxy service not detected" 

else
	sleep ${PROVIDER_HAPROXY_SVC_DELAY_MIN}

	count=${PROVIDER_HAPROXY_SVC_DELAY_MAX}
	echo "Trying discovery for ${count} seconds"

	haproxy_ip_list=$( getServiceIpAddresses "$CMS_DNSNAMES" )
	while [[ $count -ge ${PROVIDER_HAPROXY_SVC_DELAY_MIN} ]]; do
		for haproxy_candidate_ip in "${haproxy_ip_list[@]}"; do
			if dockerize -wait "tcp://${haproxy_candidate_ip}:${PROVIDER_HAPROXY_PORT_HTTP}" -timeout ${PROVIDER_HAPROXY_SVC_DELAY_STEP}s true 2&>1 >/dev/null; then
				echo "${CMS_DNSNAMES} live at IP ${haproxy_candidate_ip}"
	            break 2
			else 
				echo "${CMS_DNSNAMES} not live"
			fi	
		done	
		sleep ${PROVIDER_HAPROXY_SVC_DELAY_STEP}
    done
	echo "Detected ${CMS_DNSNAMES}"
fi