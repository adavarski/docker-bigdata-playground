FROM centos

#===============================================
# Zookeeper Version (Latest - 26/09/2018)
#===============================================
ARG VERSION=3.4.13

#===============================================
# Java
#===============================================
RUN yum install -y java-1.8.0-openjdk-devel
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk/jre

#===============================================
# Other Tools
#===============================================
RUN yum install -y wget
RUN yum install -y bash

#===============================================
# Zookeeper
#===============================================
RUN mkdir -p /opt/zookeeper
RUN wget http://apache.mirrors.pair.com/zookeeper/zookeeper-$VERSION/zookeeper-$VERSION.tar.gz
RUN tar -xzf zookeeper-$VERSION.tar.gz --strip 1 -C /opt/zookeeper

# Add configuration file (use default)
RUN cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

#===============================================
# Ports
#===============================================
# 2181 | Client connection
# 2888 | Peer communication (Peers)
# 3888 | Peer communication (Leader)
# 8080 | Zookeeper server
EXPOSE 2181 2888 3888 8080

#===============================================
# Volumes
#===============================================
VOLUME ["/opt/zookeeper/conf"]

#===============================================
# Run
#===============================================
WORKDIR /opt/zookeeper
ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
