#!/bin/sh

set -ex

project=$1

mkdir -p aidbox-project
rm -rf aidbox-project/*

cp -R aidbox-project-samples/$project/. aidbox-project
cd aidbox-project && npm install
