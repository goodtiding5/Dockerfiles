#!/bin/sh

TAG=python3-for-matrix:bionic
VER=0.30

set -ex
docker build --compress --rm -t $TAG-$VER -t $TAG-latest .
