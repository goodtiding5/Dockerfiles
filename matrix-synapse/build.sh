#!/bin/sh

TAG=matrix-base
VER=alpine-0.10

set -ex

docker build --compress --rm -t $TAG:$VER .
