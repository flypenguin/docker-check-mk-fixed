#!/usr/bin/env bash

if [ -z "$1" ] ; then

  cat build-tags.txt | parallel ./$(basename $0)

  echo ""
  echo "***** DONT FORGET TO COMMIT *****"
  echo ""


else

  TAG="$1"
  TGT_REPO="flypenguin/check-mk-fixed"
  SRC_REPO="checkmk/check-mk-raw"
  IMAGE="$TGT_REPO:$TAG"
  BUILD_MARKER="build-markers/$TAG"
  DOCKERFILE="Dockerfile.$TAG"

  if [ -f "$BUILD_MARKER" ] ; then
    echo "Tag $TAG already built. Skipping."
    exit
  fi

  set -euo pipefail

  cat Dockerfile \
    | sed -Ee "s%^FROM.*%FROM $SRC_REPO:$TAG%g" > Dockerfile.$TAG

  docker build -t "$IMAGE" -f "$DOCKERFILE" .
  docker push $IMAGE
  touch "$BUILD_MARKER"

fi
