FROM base-hadoop

MAINTAINER davar

#===============================================
# Volume
#===============================================
VOLUME ["/hdfs"]

#===============================================
# Entrypoint
#===============================================
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

