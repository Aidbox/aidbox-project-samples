#!/bin/sh

. ./.env

healthcheck_status() { curl 'http://localhost:8888/__healthcheck' -s -o /dev/null -w '%{http_code}' ; }

while [ "$(healthcheck_status)" != 200 ]
do
    echo localhost:8888 unhealthy
    sleep 1
done

echo localhost:8888 healthy
