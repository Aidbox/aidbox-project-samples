#!/bin/sh

set -ex

. ./.env

./scripts/aidbox-healthcheck.sh || exit 1

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -X PUT 'http://localhost:8888/' \
     -H 'Content-Type: text/yaml' \
     --data-binary "@./scripts/plannet/search-parameters.yaml"

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     'http://localhost:8888/fhir/$load' \
     -H 'content-type: text/yaml' \
     -d 'source: /aidbox-project/01-load-resources.ndjson.gz'

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     'http://localhost:8888/fhir' \
     -H 'content-type: text/yaml' \
     --data-binary '@./scripts/plannet/02-create-resource.yaml'

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     'http://localhost:8888/fhir' \
     -H 'content-type: text/yaml' \
     --data-binary '@./scripts/plannet/03-delete-resource.yaml'

mkdir -p aidbox-project

cp -R aidbox-project-samples/plannet/. aidbox-project
cd aidbox-project && npm install

echo 'plannet' > './.type'
# check that there are no errors in zen config
