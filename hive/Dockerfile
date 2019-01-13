FROM base-centos

MAINTAINER davar

USER root

#===============================================
# Cloudera Repo
#===============================================
ADD cloudera-cdh5.repo /etc/yum.repos.d/
RUN rpm --import https://archive.cloudera.com/cdh5/redhat/5/x86_64/cdh/RPM-GPG-KEY-cloudera

#===============================================
# Install Packages
#===============================================
RUN yum install -y wget
RUN yum install -y postgresql 
RUN yum install -y hive 
RUN yum install -y hive-hbase 
RUN yum install -y hive-jdbc 
RUN yum install -y hive-metastore 
RUN yum install -y hive-server2
RUN yum clean all

#===============================================
# Postgres Jar
#===============================================
RUN wget https://jdbc.postgresql.org/download/postgresql-9.4.1209.jre7.jar -O /usr/lib/hive/lib/postgresql-9.4.1209.jre7.jar

#===============================================
# Apache Maven
#===============================================
WORKDIR /usr/local/src
RUN wget http://apache.mirror.digitalpacific.com.au/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
RUN tar -xvzf apache-maven-3.5.4-bin.tar.gz
RUN rm -f apache-maven-3.5.4-bin.tar.gz
RUN mv apache-maven-3.5.4/ apache-maven/

# Add Maven configuration file
ADD config/maven.sh /etc/profile.d/
RUN chmod +x /etc/profile.d/maven.sh
RUN source /etc/profile.d/maven.sh

# Add test JDBC project and package with maven
WORKDIR /
RUN mkdir jdbc/
ADD jdbc/ jdbc/

#===============================================
# Hadoop Configuration Files
#===============================================
WORKDIR /
ADD config/core-site.xml /etc/hadoop/conf/
ADD config/hdfs-site.xml /etc/hadoop/conf/

#===============================================
# Hive Configuration Files
#===============================================
ADD config/hbase-site.xml /etc/hadoop/conf/
ADD config/hive-site.xml /etc/hadoop/conf/

#===============================================
# Ports
#===============================================
# Expose Hive ports
# 9083  | Hive Metastore
# 10000 | HiveServer2
# 10002 | HiveServer2 web UI
EXPOSE 9083 10000 10002

#===============================================
# Entrypoint
#===============================================
COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
