#!/usr/bin/env bash
#
# Assert the changes made by this action.
#

set -eu -o pipefail

source common.sh

echo "# Asserting the Container Registry rollout status..."
rollout_status "${REGISTRY_NAMESPACE}" "registry"

echo "# Asserting the /etc/hosts have been patched..."
if ! grep -E -q '127.0.0.1.*registry' /etc/hosts ; then
	fail "/etc/hosts does not include the registry hostname"
fi

echo "# Asserting the Tekton Pipeline Controller"
rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-controller"

echo "# Asserting the Tekton Pipeline WebHook"
rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-webhook"

echo "# Asserting the Shipwright Build Controller"
rollout_status "${SHIPWRIGHT_NAMESPACE}" "shipwright-build-controller"

echo "# Asserting the CLI (shp) is installed"
probe_bin_on_path "shp"
