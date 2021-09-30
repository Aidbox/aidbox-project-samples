#!/bin/sh

set -ex

. ./.env

curl "${AIDBOX_BASE_URL}" \
     -X PUT \
     -o /dev/null \
     -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -H 'Content-Type: text/yaml' \
     --data-binary "@./scripts/plannet/search-parameters.yaml"

curl "${AIDBOX_BASE_URL}/fhir" \
     -o /dev/null \
     -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -H 'content-type: text/yaml' \
     --data-binary '@./scripts/plannet/01-load-resources.yaml'

curl "${AIDBOX_BASE_URL}/fhir" \
     -o /dev/null \
     -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -H 'content-type: text/yaml' \
     --data-binary '@./scripts/plannet/02-create-resource.yaml'

curl "${AIDBOX_BASE_URL}/fhir" \
     -o /dev/null \
     -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -H 'content-type: text/yaml' \
     --data-binary '@./scripts/plannet/03-delete-resource.yaml'
