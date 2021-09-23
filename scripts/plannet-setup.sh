#!/bin/sh

set -ex

pwd
. ./.env


./scripts/aidbox-healthcheck.sh || exit 1

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -X PUT 'http://localhost:8888/' \
     -H 'Content-Type: text/yaml' \
     --data-binary "@./scripts/plannet/search-parameters.yaml"

mkdir -p aidbox-project

cp -R aidbox-project-samples/plannet/* aidbox-project/
cd aidbox-project && pwd && ls && npm install

echo 'plannet' > './.type'
# check that there are no errors in zen config
