#!/bin/sh

rm -rf target

mkdir -p target

cp -R src/* target
cp node_modules target/node_modules
