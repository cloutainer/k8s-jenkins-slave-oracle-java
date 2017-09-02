#!/bin/bash

set -e

#
# INSTALL SDKMAN
#
export SDKMAN_DIR="/opt/sdkman"
bash   /opt/install-sdkman.sh
source /opt/sdkman/bin/sdkman-init.sh
sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' /opt/sdkman/etc/config

#
# INSTALL SDKS
#
sdk install java     8u141-oracle
sdk install gradle   4.1
sdk install maven    3.5.0
sdk install groovy   2.4.9

#
# CLEANUP
#
rm -rf /opt/sdkman/tmp/*
rm -rf /opt/sdkman/archives/*
