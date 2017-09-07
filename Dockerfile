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
# ORACLE JAVA
#
ENV JAVA_VMAJOR 8
ENV JAVA_VMINOR 141
ENV JAVA_SHA512 1ffaf30d2d8af71e1fe694d13a7cc4b135ce9ed5d3d2f1a39045d1bd6dbfa22d2f8656371b52312bb4f65e48e01f223d463022ef860da5b4a6453a5c165ab074
ENV JAVA_DOHASH 336fa29ff2bb4ef291e347e091f7f4a7
RUN echo "${JAVA_SHA512}  /opt/jdk-${JAVA_VMAJOR}u${JAVA_VMINOR}-linux-x64.tar.gz" > /opt/jdk-${JAVA_VMAJOR}u${JAVA_VMINOR}-linux-x64.tar.gz.sha512 && \
    curl -jkSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /opt/jdk-${JAVA_VMAJOR}u${JAVA_VMINOR}-linux-x64.tar.gz \
         http://download.oracle.com/otn-pub/java/jdk/${JAVA_VMAJOR}u${JAVA_VMINOR}-b15/${JAVA_DOHASH}/jdk-${JAVA_VMAJOR}u${JAVA_VMINOR}-linux-x64.tar.gz && \
    sha512sum -c /opt/jdk-${JAVA_VMAJOR}u${JAVA_VMINOR}-linux-x64.tar.gz.sha512 && \
    tar -C /opt -xf /opt/jdk-${JAVA_VMAJOR}u${JAVA_VMINOR}-linux-x64.tar.gz && \
    mv /opt/jdk1.${JAVA_VMAJOR}.0_${JAVA_VMINOR} /opt/jdk && \
    rm -f /opt/jdk-${JAVA_VMAJOR}u${JAVA_VMINOR}-linux-x64.tar.gz && \
    rm -f /opt/jdk/src.zip /opt/jdk/javafx-src.zip && \
    chown jenkins /opt/jdk/jre/lib/security/cacerts && \
    update-alternatives --install "/usr/bin/java" "java" "/opt/jdk/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/opt/jdk/bin/javac" 1 && \
    update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/jdk/bin/javaws" 1 && \
    update-alternatives --install "/usr/bin/jar" "jar" "/opt/jdk/bin/jar" 1 && \
    update-alternatives --set "java" "/opt/jdk/bin/java" && \
    update-alternatives --set "javac" "/opt/jdk/bin/javac" && \
    update-alternatives --set "javaws" "/opt/jdk/bin/javaws" && \
    update-alternatives --set "jar" "/opt/jdk/bin/jar"

#
# APACHE MAVEN
#
RUN curl -jkSL -o /opt/maven.tar.gz http://ftp.fau.de/apache/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz && \
    tar -C /opt -xf /opt/maven.tar.gz && \
    rm -f /opt/maven.tar.gz && \
    mv /opt/apache-maven-* /opt/apache-maven/

#
# GRADLE
#
RUN curl -jkSL -o /opt/gradle.zip https://services.gradle.org/distributions/gradle-4.1-bin.zip && \
    unzip /opt/gradle.zip -d /opt/ && \
    rm -f /opt/gradle.zip && \
    mv /opt/gradle-* /opt/gradle/

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
