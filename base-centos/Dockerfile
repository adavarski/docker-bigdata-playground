FROM centos

MAINTAINER davar 

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk/jre

RUN yum update -y
RUN yum install -y java-1.8.0-openjdk-devel wgemt unzip curl vim python-setuptools
RUN yum clean all

CMD ["/bin/bash"]
