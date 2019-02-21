FROM cloutainer/k8s-jenkins-slave-base:v21

#
# USER: super
#
USER root

#
# ATLASSIAN SDK
#

ENV ATLS_VERSIN 8.0.7
ENV ATLS_SHA512 b1616fa7dc879c64605c7a55dfdd9491c4ca8015f8aee049d58affe97372bbdc65167f8720a52bd7fdc76f9c0d128705da8168caff90394f34d8e8f2d515509b
RUN echo "${ATLS_SHA512}  /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz" > /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz.sha512 && \
    curl -jkSL -o /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz \
    https://packages.atlassian.com/maven/repository/public/com/atlassian/amps/atlassian-plugin-sdk/${ATLS_VERSIN}/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz && \
    sha512sum /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz && \
    sha512sum -c /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz.sha512 && \
    tar -C /opt -xf /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz && \
    chown -R jenkins:root /opt/atlassian-plugin-sdk-${ATLS_VERSIN} && \
    rm -f /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz

#
# ORACLE OPENJDK JAVA
#
ENV JAVA_SHA512 8e04d22fe03d2ab92e48fbbfe7d6015d9062d8e767d55ca9235e02b39841236d47b8977ae0252d5f4351a4c5fe082d377e2f8978156cf73c0208028a422e5e4c
RUN echo "${JAVA_SHA512}  /opt/jdk--linux-x64.tar.gz" > /opt/jdk--linux-x64.tar.gz.sha512 && \
    curl -jkSL -o /opt/jdk-linux-x64.tar.gz \
    "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u202b08.tar.gz" && \
    tar -C /opt -xf /opt/jdk-linux-x64.tar.gz && \
    mv /opt/jdk8u202-b08 /opt/jdk && \
    rm -f /opt/jdk-linux-x64.tar.gz && \
    chown jenkins /opt/jdk/jre/lib/security/cacerts && \
    update-alternatives --install "/usr/bin/java" "java" "/opt/jdk/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/opt/jdk/bin/javac" 1 && \
    #update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/jdk/bin/javaws" 1 && \
    update-alternatives --install "/usr/bin/jar" "jar" "/opt/jdk/bin/jar" 1 && \
    update-alternatives --set "java" "/opt/jdk/bin/java" && \
    update-alternatives --set "javac" "/opt/jdk/bin/javac" && \
    #update-alternatives --set "javaws" "/opt/jdk/bin/javaws" && \
    update-alternatives --set "jar" "/opt/jdk/bin/jar"

#
# APACHE MAVEN
#
RUN curl -jkSL -o /opt/maven.tar.gz http://www-eu.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz && \
    tar -C /opt -xf /opt/maven.tar.gz && \
    rm -f /opt/maven.tar.gz && \
    mv /opt/apache-maven-* /opt/apache-maven/

#
# GRADLE
#
RUN curl -jkSL -o /opt/gradle.zip https://services.gradle.org/distributions/gradle-4.10.2-bin.zip && \
    unzip /opt/gradle.zip -d /opt/ && \
    rm -f /opt/gradle.zip && \
    mv /opt/gradle-* /opt/gradle/


#
# KUBERNETES CLI (kubectl)
#
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

#
# INSTALL AND CONFIGURE
#
COPY docker-entrypoint-hook.sh /opt/docker-entrypoint-hook.sh
RUN chmod u+rx,g+rx,o+rx,a-w /opt/docker-entrypoint-hook.sh

#
# USER: normal
#
USER jenkins

#
# RUN
#
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:/opt/atlassian-plugin-sdk-${ATLS_VERSIN}/bin/:/opt/jdk/bin:/opt/gradle/bin:/opt/apache-maven/bin
USER jenkins
