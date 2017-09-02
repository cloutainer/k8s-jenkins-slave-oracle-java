#!/bin/bash

set -e

echo "DOCKER-ENTRYPOINT-HOOK >> init"

export SDKMAN_DIR="/opt/sdkman"
source /opt/sdkman/bin/sdkman-init.sh


#
# IMPORT KUBERNETES ca.crt (OPTIONAL)
#
if [ -n "$KUBERNETES_CA_BASE64" ]
then
  echo $KUBERNETES_CA_BASE64 | base64 --decode > /tmp/kube-ca.crt
  echo "DOCKER-ENTRYPOINT-HOOK >> KUBERNETES_CA_BASE64 ENV VAR > importing kubernetes ca certificate to java keystore."
  cat /tmp/kube-ca.crt
  keytool -importcert -keystore /opt/sdkman/candidates/java/8u141-oracle/jre/lib/security/cacerts -alias kubernetes -file /tmp/kube-ca.crt -storepass changeit -noprompt
else
  echo "DOCKER-ENTRYPOINT-HOOK >> KUBERNETES_CA_BASE64 ENV VAR > not set. SKIPPING importing of kubernetes ca certificate."
fi
