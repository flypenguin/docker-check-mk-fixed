#!/usr/bin/env bash

echo "NEW ENTRYPOINT STARTED"

set -x

cd /
sed -Ei 's%^wait( .*)?$%/fix-docker.sh%g' docker-entrypoint.sh
echo wait >> docker-entrypoint.sh

exec ./docker-entrypoint.sh

