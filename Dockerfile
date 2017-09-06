FROM cloutainer/k8s-jenkins-slave-base:v21

#
# USER: super
#
USER root

#
# ATLASSIAN SDK
#
ENV ATLS_VERSIN 6.2.14
ENV ATLS_SHA512 48ad1d0c8ee725ee0e6753231e061ac04da54167797429d39ed8a4815b6705d0fc643794bf767809d819fc22039fe8923e8a94bb9aa3bf2a6e32a25f53039153
RUN echo "${ATLS_SHA512}  /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz" > /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz.sha512 && \
    curl -jkSL -o /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz \
         https://maven.atlassian.com/content/repositories/atlassian-public/com/atlassian/amps/atlassian-plugin-sdk/${ATLS_VERSIN}/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz && \
    sha512sum -c /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz.sha512 && \
    tar -C /opt -xf /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz && \
    chown -R jenkins:root /opt/atlassian-plugin-sdk-${ATLS_VERSIN} && \
    rm -f /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz

#
# INSTALL AND CONFIGURE
#
COPY docker-entrypoint-hook.sh /opt/docker-entrypoint-hook.sh
COPY install-sdks.sh /opt/install-sdks.sh
COPY install-sdkman.sh /opt/install-sdkman.sh
RUN chmod u+rx,g+rx,o+rx,a-w /opt/docker-entrypoint-hook.sh && \
    chmod u+rx,g+rx,o+rx,a-w /opt/install-sdks.sh && \
    mkdir -p /opt/sdkman && \
    chown jenkins:jenkins /opt/sdkman/ && \
    chmod -R +x /opt/sdkman/

#
# USER: normal
#
USER jenkins

#
# SDKS AND TOOLS
#
RUN bash /opt/install-sdks.sh

#
# RUN
#
ENV PATH ${PATH}:/opt/atlassian-plugin-sdk-${ATLS_VERSIN}/bin/
USER jenkins
