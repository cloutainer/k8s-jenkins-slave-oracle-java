#!/bin/bash

set -e

curl -s "https://get.sdkman.io" | bash

source "/home/jenkins/.sdkman/bin/sdkman-init.sh"

sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' /home/jenkins/.sdkman/etc/config

sdk install java 8u141-oracle

sdk install gradle 4.1

sdk install maven 3.5.0

sdk install groovy 2.4.9
