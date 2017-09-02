#!/bin/bash

set -e

echo "DOCKER-ENTRYPOINT-HOOK >> init"

export SDKMAN_DIR="/opt/sdkman"
source /opt/sdkman/bin/sdkman-init.sh
