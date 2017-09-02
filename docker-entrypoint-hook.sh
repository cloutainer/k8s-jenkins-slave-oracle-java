#!/bin/bash

set -e

echo "DOCKER-ENTRYPOINT-HOOK >> init"

if [ "$MAVEN_REPOSITORY_MIRROR" != "false" ]
then
    echo "DOCKER-ENTRYPOINT-HOOK >> INJECTING MAVEN REPOSITORY MIRROR WITH URL: ${MAVEN_REPOSITORY_MIRROR}"
    ATLAS_MAVEN_HOME=$(atlas-version | grep "ATLAS Maven Home" | awk '{print $4}') && \
    sed -i "s@<mirrors>@<mirrors><mirror><mirrorOf>*</mirrorOf><name>remote-repos</name><url>${MAVEN_REPOSITORY_MIRROR}</url><id>remote-repos</id></mirror>@g" $ATLAS_MAVEN_HOME/conf/settings.xml
fi
