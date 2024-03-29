FROM cloutainer/k8s-jenkins-slave-base:v24

#
# USER: super
#
USER root

#
# ATLASSIAN SDK
#
ENV ATLS_VERSIN 8.2.7
RUN curl -jkSL -o /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz \
    https://packages.atlassian.com/maven/repository/public/com/atlassian/amps/atlassian-plugin-sdk/${ATLS_VERSIN}/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz && \
    tar -C /opt -xf /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz && \
    chown -R jenkins:root /opt/atlassian-plugin-sdk-${ATLS_VERSIN} && \
    rm -f /opt/atlassian-plugin-sdk-${ATLS_VERSIN}.tar.gz

#
# ORACLE OPENJDK JAVA
#
RUN curl -jkSL -o /opt/jdk-linux-x64.tar.gz \
    "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_x64_linux_hotspot_8u322b06.tar.gz" && \
    tar -C /opt -xf /opt/jdk-linux-x64.tar.gz && \
    ls -lah /opt && \
    mv /opt/jdk8u* /opt/jdk && \
    rm -f /opt/jdk-linux-x64.tar.gz && \
    chown jenkins /opt/jdk/lib/security/cacerts | true && \
    chown jenkins /opt/jdk/jre/lib/security/cacerts | true && \
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
RUN curl -jkSL -o /opt/maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz && \
    tar -C /opt -xf /opt/maven.tar.gz && \
    rm -f /opt/maven.tar.gz && \
    mv /opt/apache-maven-* /opt/apache-maven/

#
# GRADLE
#
RUN curl -jkSL -o /opt/gradle.zip https://services.gradle.org/distributions/gradle-7.4.2-bin.zip && \
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
# 2022-04 Since AMPS 8.3.x we need to tell the SDK to use Maven > 3.6.x => the bundled version is not compatible!
ENV ATLAS_MVN /opt/apache-maven/bin/mvn
ENV PATH ${PATH}:/opt/atlassian-plugin-sdk-${ATLS_VERSIN}/bin/:/opt/jdk/bin:/opt/gradle/bin:/opt/apache-maven/bin
USER jenkins
