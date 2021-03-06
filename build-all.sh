#!/usr/bin/env bash

if [ -z "$1" ] ; then

  cat build-tags.txt | while read BUILD_TAG ; do
    ./$(basename $0) $BUILD_TAG
  done

  # parallel was so ... non-noisy. I want to see whats going on.
  #parallel ./$(basename $0)

  echo ""
  echo "***** DONT FORGET TO COMMIT *****"
  echo ""


else

  TAG="$1"
  TGT_REPO="flypenguin/check-mk-fixed"
  SRC_REPO="checkmk/check-mk-raw"
  REVISION=$(cat build-revision)
  IMAGE_TAG="$TAG-r$REVISION"
  IMAGE="$TGT_REPO:$IMAGE_TAG"
  BUILD_MARKER="build-markers/$IMAGE_TAG"
  DOCKERFILE="Dockerfile.$TAG"

  set -e
  if [ -f "$BUILD_MARKER" ] ; then
    echo "Tag $TAG already built. Skipping."
    exit
  fi

  set -euo pipefail

  cat Dockerfile \
    | sed -Ee "s%^FROM.*%FROM $SRC_REPO:$TAG%g" > Dockerfile.$TAG

  docker build -t "$IMAGE" -f "$DOCKERFILE" .
  echo "$IMAGE" > "$BUILD_MARKER"

fi
