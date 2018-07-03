#!/bin/bash

set -o errexit
set -o errtrace
set -o pipefail
set -x

export ROOT_FOLDER
ROOT_FOLDER="$( pwd )"
export REPO_RESOURCE=repo
export TOOLS_RESOURCE=tools
export KEYVAL_RESOURCE=keyval
export KEYVALOUTPUT_RESOURCE=keyvalout
export OUTPUT_RESOURCE=out

echo "Root folder is [${ROOT_FOLDER}]"
echo "Repo resource folder is [${REPO_RESOURCE}]"
echo "Tools resource folder is [${TOOLS_RESOURCE}]"
echo "KeyVal resource folder is [${KEYVAL_RESOURCE}]"

# If you're using some other image with Docker change these lines
# shellcheck source=/dev/null

[ -f /docker-lib.sh ] && source /docker-lib.sh || echo "Failed to source docker-lib.sh... Hopefully you know what you're doing"
start_docker || echo "Failed to start docker... Hopefully you know what you're doing"

echo "PRE pipeline.sh"
# shellcheck source=/dev/null
source "${ROOT_FOLDER}/${TOOLS_RESOURCE}/concourse/tasks/pipeline.sh"
echo "POST pipeline.sh"


echo "${MESSAGE}"
cd "${ROOT_FOLDER}/${REPO_RESOURCE}" || exit
echo "cded into ${ROOT_FOLDER}/${REPO_RESOURCE}"

echo "exporting keyval props"
exportKeyValProperties
# generate a test-env prefix
appName=$(retrieveAppName)
echo "going to delete space ${PASSED_TEST_SPACE_PREFIX}-${appname}"

logInToPaas

"${CF_BIN}" delete-space "${PASSED_TEST_SPACE_PREFIX}-${appname}" -f

