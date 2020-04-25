#!/usr/bin/env bash

TGT_REPO="flypenguin/check-mk-fixed"
SRC_REPO="checkmk/check-mk-raw"
IMAGE="$TGT_REPO:$TAG"
BUILD_MARKER_DIR="build-markers/$TAG"
DOCKERFILE="Dockerfile.$TAG"

cd "$BUILD_MARKER_DIR"

for TAG in * ; do

  grep -q pushed "$TAG" && echo "$TAG pushed, skipping" && continue

  IMAGE=$(cat "$TAG")
  docker push $IMAGE
  echo "pushed" >> "$TAG"

done
