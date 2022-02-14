#!/bin/sh

set -ex

. ./.env

./scripts/aidbox-healthcheck.sh || exit 1

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -X POST 'http://localhost:8888/fhir/$load' \
     -H 'Content-Type: application/json' \
     --data-raw '{"source": "https://storage.googleapis.com/aidbox-public/inferno/inferno-community-fixtures.ndjson.gz"}'

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -X PUT 'http://localhost:8888/Client' \
     -H 'Content-Type: application/json' \
     --data-raw '{ "auth" : { "authorization_code" : { "audience" : [ "'"${AIDBOX_BASE_URL}"'/smart" ], "redirect_uri" : "https://touchstone.aegis.net/touchstone/oauth2/authcode/redirect", "refresh_token" : true, "access_token_expiration" : 300 } }, "secret" : "touchstone-secret", "grant_types" : [ "code", "basic" ], "id" : "touchstone-client", "resourceType" : "Client" }'

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -X PUT 'http://localhost:8888/' \
     -H 'Content-Type: text/yaml' \
     --data-binary "@./scripts/smart-on-fhir-resources/client.yaml"

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -X PUT 'http://localhost:8888/' \
     -H 'Content-Type: text/yaml' \
     --data-binary "@./scripts/smart-on-fhir-resources/patient-user.yaml"

curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
     -X PUT 'http://localhost:8888/' \
     -H 'Content-Type: text/yaml' \
     --data-binary "@./scripts/smart-on-fhir-resources/access-policies.yaml"

mkdir -p aidbox-project
rm -rf aidbox-project/*

cp -R aidbox-project-samples/smart-on-fhir/. aidbox-project
cd aidbox-project && npm install

# check that there are no errors in zen config
