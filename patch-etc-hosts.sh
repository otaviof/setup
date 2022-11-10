#!/usr/bin/env bash
#
# Patches /etc/hosts to include the registry FQDN resolving to localhost.
#

set -eu -o pipefail
set -x

REGISTRY_HOSTNAME=${REGISTRY_HOSTNAME:-registry.registry.svc.cluster.local}
HOSTS_ENTRY="127.0.0.1    ${REGISTRY_HOSTNAME}"

readonly ETC_HOSTS="/etc/hosts"

if ! grep -q "${HOSTS_ENTRY}" ${ETC_HOSTS} ; then
	echo "${HOSTS_ENTRY}" |tee -a ${ETC_HOSTS}
fi
