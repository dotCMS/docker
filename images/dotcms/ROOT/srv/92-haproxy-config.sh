#!/bin/bash

set -e

source /srv/utils/config-defaults.sh

echo "Haproxy config ...."

if [[ -z "${CMS_DNSNAMES}" ]]; then

    echo "Haproxy service not detected" 

else
	echo "Detected Haproxy service ${CMS_DNSNAMES}"
fi