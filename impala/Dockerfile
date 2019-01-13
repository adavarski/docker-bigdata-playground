FROM base-centos

MAINTAINER davar

USER root

#===============================================
# Installation Repository
#===============================================
ADD cloudera-cdh5.repo /etc/yum.repos.d/
RUN rpm --import https://archive.cloudera.com/cdh5/redhat/5/x86_64/cdh/RPM-GPG-KEY-cloudera

#===============================================
# Install Impala
#===============================================
RUN yum install -y impala
RUN yum install -y impala-server
RUN yum install -y impala-shell
RUN yum install -y impala-catalog
RUN yum install -y impala-state-store
RUN yum clean all

#===============================================
# Configure Sockets
#===============================================
RUN mkdir -p /var/run/hdfs-sockets
RUN chown hdfs.hadoop /var/run/hdfs-sockets
RUN mkdir -p /data/dn/
RUN chown hdfs.hadoop /data/dn

#===============================================
# User Permissions
#===============================================
RUN groupadd supergroup
RUN usermod -a -G supergroup impala
RUN usermod -a -G hdfs impala
RUN usermod -a -G supergroup hive
RUN usermod -a -G hdfs hive

#===============================================
# Configuration Files
#===============================================
WORKDIR /
ADD config/core-site.xml /etc/impala/conf/
ADD config/hdfs-site.xml /etc/impala/conf/
ADD config/mapred-site.xml /etc/impala/conf/
ADD config/hive-site.xml /etc/impala/conf/

#===============================================
# Expose Ports
#===============================================
# 21000 | Execute Impala-Shell commands
# 21050 | Execute application commands (ie. JDBC)
# 25000 | Impala Web Interface
# 25010 | Impala StateStore
# 25020 | Catalog Service Web Interface
EXPOSE 21000 21050 25000 25010 25020

#===============================================
# Entrypoint
#===============================================
COPY entrypoint.sh /
CMD ["/entrypoint.sh"]

