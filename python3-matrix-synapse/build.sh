#!/bin/sh

NAME=matrix:0.33.9-bionic
VER=0.50
TAG="$NAME-$VER"

set -ex

docker build --compress --rm -t $TAG .
