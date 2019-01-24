#!/bin/sh

NAME=coturn:alpine
VER=0.7

TAG="$NAME-$VER"
TAG1="$NAME-latest"

set -ex

docker build --rm -t $TAG -t $TAG1 .
