#!/bin/sh
TAG="elixir-node:1.8-10.15-alpine"
docker build --rm --compress -t $TAG .
