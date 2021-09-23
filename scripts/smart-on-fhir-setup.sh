#!/bin/sh

set -ex

. .env


status=`curl 'http://localhost:8888/__healthcheck' -s -o /dev/null -w '%{http_code}' || true`
while [ $status != 200 ]
do
    echo localhost:8888 unhealthy
    sleep 1
    status=`curl 'http://localhost:8888/__healthcheck' -s -o /dev/null -w '%{http_code}' || true`
done
echo localhost:8888 healthy


curl -o /dev/null -u ${AIDBOX_CLIENT_ID}:${AIDBOX_CLIENT_SECRET} \
    -X POST 'http://localhost:8888/fhir/$load' \
    -H 'Content-Type: application/json' \
    --data-raw '{"source": "https://storage.googleapis.com/aidbox-public/inferno/inferno-community-fixtures.ndjson.gz"}'

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

cp -R aidbox-project-samples/smart-on-fhir/ aidbox-project
cd aidbox-project && npm install

# check that there are no errors in zen config
