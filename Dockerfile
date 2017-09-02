FROM cloutainer/k8s-jenkins-slave-base:v16

#
# SDKS AND TOOLS
#
RUN curl -s "https://get.sdkman.io" | bash && \
    sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' /root/.sdkman/etc/config && \
    sdk install java 8u141-oracle && \
    sdk install gradle 4.1 && \
    sdk install maven 3.5.0 && \
    sdk install groovy 2.4.9

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
RUN chmod u+rx,g+rx,o+rx,a-w /opt/docker-entrypoint-hook.sh

#
# RUN
#
ENV MAVEN_REPOSITORY_MIRROR "false"
ENV PATH ${PATH}:/opt/atlassian-plugin-sdk-${ATLS_VERSIN}/bin/
USER jenkins
