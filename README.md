<img src="https://cloutainer.github.io/documentation/images/cloutainer.svg?v5" align="right">

# k8s-jenkins-slave-oracle-java

[![](https://codeclou.github.io/doc/badges/generated/docker-image-size-565.svg)](https://hub.docker.com/r/cloutainer/k8s-jenkins-slave-oracle-java/tags/) [![](https://codeclou.github.io/doc/badges/generated/docker-from-ubuntu-16.04.svg)](https://www.ubuntu.com/) [![](https://codeclou.github.io/doc/badges/generated/docker-run-as-non-root.svg)](https://docs.docker.com/engine/reference/builder/#/user)

Kubernetes Docker image providing Jenkins Slave JNLP with Oracle Java and Atlassian SDK.

-----
&nbsp;

### Preinstalled Tools

| tool | version |
|------|---------|
| java jdk | Oracle 8u141 |
| atlassian sdk | 6.1.14 |
| maven | 3.5.0 |
| gradle | 4.1 |
| groovy | 2.4.9 |
| cloudfoundry cli | apt-get |
| kubernetes cli | apt-get |
| docker cli`*` | apt-get |
| git | apt-get |
| curl, wget | apt-get |
| zip, bzip2 | apt-get |
| jq | apt-get |

`*` You need to mount the `/var/run/docker.sock` as volume.

-----
&nbsp;

### Usage


Use with [Kubernetes Jenkins Plugin](https://github.com/jenkinsci/kubernetes-plugin) like so:

```groovy
podTemplate(
  name: 'java-v11',
  label: 'k8s-jenkins-slave-oracle-java-v11',
  cloud: 'mycloud',
  nodeSelector: 'failure-domain.beta.kubernetes.io/zone=eu-west-1a',
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'cloutainer/k8s-jenkins-slave-oracle-java:v11',
      privileged: false,
      command: '/opt/docker-entrypoint.sh',
      args: '',
      alwaysPullImage: false,
      workingDir: '/home/jenkins',
      resourceRequestCpu: '500m',
      resourceLimitCpu: '1',
      resourceRequestMemory: '3000Mi',
      resourceLimitMemory: '3000Mi'
    )
  ]
) {
  node('k8s-jenkins-slave-oracle-java-v11') {
    stage('build and test') {
      sh 'git clone https://github.com/spring-projects/spring-boot.git code'
      dir('code') {
        dir('spring-boot-samples') {
          dir('spring-boot-sample-war') {
            sh 'mvn compile'
          }
        }
      }
    }
  }
}
```


**Debug** - Open a bash to e.g. check the tools

```
docker run -i -t --entrypoint "/bin/bash" cloutainer/k8s-jenkins-slave-oracle-java:v11
$> atlas-version
...
$> java -version
...
$> gradle -version
...
```
-----
&nbsp;

### Trademarks and Third Party Licenses

 * **Atlassian SDK**
   * Atlassian® are registered [trademarks of Atlassian Pty Ltd](https://de.atlassian.com/legal/trademark).
   * Please check yourself for corresponding Licenses and Terms of Use at [atlassian.com](https://atlassian.com).
 * **Oracle Java JDK 8**
   * Oracle and Java are registered [trademarks of Oracle](https://www.oracle.com/legal/trademarks.html) and/or its affiliates. Other names may be trademarks of their respective owners.
   * Please check yourself for corresponding Licenses and Terms of Use at [www.oracle.com](https://www.oracle.com/).
 * **Docker**
   * Docker and the Docker logo are trademarks or registered [trademarks of Docker](https://www.docker.com/trademark-guidelines), Inc. in the United States and/or other countries. Docker, Inc. and other parties may also have trademark rights in other terms used herein.
   * Please check yourself for corresponding Licenses and Terms of Use at [www.docker.com](https://www.docker.com/).
 * **Ubuntu**
   * Ubuntu and Canonical are registered [trademarks of Canonical Ltd.](https://www.ubuntu.com/legal/short-terms)

-----
&nbsp;

### License

[MIT](https://github.com/cloutainer/k8s-jenkins-slave-oracle-java-atlassian-sdk/blob/master/LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
