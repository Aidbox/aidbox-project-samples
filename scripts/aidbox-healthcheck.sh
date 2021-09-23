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
