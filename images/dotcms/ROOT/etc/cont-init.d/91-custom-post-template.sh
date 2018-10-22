#!/usr/bin/with-contenv /bin/bash

# Exit 1 in case any command in this script fails. Highly recommend DO NOT CHANGE this for proper error handling.
#  Container should abort in case of failed init task.
set -e

# Import all config defaults
source /srv/docker-container/utils/config-defaults.sh

## Override this file to add your custom init script here.  This script will run as root, and have access to all config variables.