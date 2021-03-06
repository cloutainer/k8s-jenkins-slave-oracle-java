#!/bin/bash

set -e

echo "DOCKER-ENTRYPOINT-HOOK >> init"

#
# IMPORT KUBERNETES ca.crt (OPTIONAL)
#
if [ -n "$KUBERNETES_CA_BASE64" ]
then
  echo $KUBERNETES_CA_BASE64 | base64 --decode > /tmp/kube-ca.crt
  echo "DOCKER-ENTRYPOINT-HOOK >> KUBERNETES_CA_BASE64 ENV VAR > importing kubernetes ca certificate to java keystore."
  cat /tmp/kube-ca.crt
  if [[ -f "/opt/jdk/jre/lib/security/cacerts" ]]
  then
    keytool -importcert -keystore /opt/jdk/jre/lib/security/cacerts -alias kubernetes -file /tmp/kube-ca.crt -storepass changeit -noprompt
  fi
  if [[ -f "/opt/jdk/lib/security/cacerts" ]]
  then
    keytool -importcert -keystore /opt/jdk/lib/security/cacerts -alias kubernetes -file /tmp/kube-ca.crt -storepass changeit -noprompt
  fi
else
  echo "DOCKER-ENTRYPOINT-HOOK >> KUBERNETES_CA_BASE64 ENV VAR > not set. SKIPPING importing of kubernetes ca certificate."
fi
