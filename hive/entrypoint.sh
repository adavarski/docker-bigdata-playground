#!/bin/bash

# Wait for Zookeeper to Start
echo "Waiting for Zookeeper to start..."
timeout 120 bash -c 'until echo > /dev/tcp/zookeeper/2181; do sleep 0.5; done' &>/dev/null || \
{
        echo -e "#######################################################";
        echo -e "HIVE ERROR: Zookeeper did not start within 120 seconds.";
        echo -e "#######################################################";
        exit;
}
echo "Zookeeper Started."

# Wait for Postgres to Start
echo "Waiting for PostgreSQL to start..."
timeout 120 bash -c 'until echo > /dev/tcp/postgres/5432; do sleep 0.5; done' &>/dev/null || \
{
        echo -e "########################################################";
        echo -e "HIVE ERROR: PostgreSQL did not start within 120 seconds.";
        echo -e "########################################################";
        exit;
}
echo "PostgreSQL Started."

# Wait for NameNode to Start
echo "Waiting for NameNode to start..."
timeout 120 bash -c 'until echo > /dev/tcp/namenode/8020; do sleep 0.5; done' &>/dev/null || \
{
        echo -e "#############################################################";
        echo -e "HIVE ERROR: Hadoop NameNode did not start within 120 seconds.";
        echo -e "#############################################################";
        exit;
}
echo "NameNode Started."

# Create the metastore database
psql -h postgres -U postgres -c "CREATE DATABASE metastore;"
/usr/lib/hive/bin/schematool -dbType postgres -initSchema

# Start the Hive metastore
/etc/init.d/hive-metastore start

# Start Hive Server 2
/etc/init.d/hive-server2 start

echo
echo "=================================================="
echo "================== Hive Started ==================" 
echo "=================================================="
echo

# Run health check on running processes
while sleep 60; do
  ps aux |grep hive-metastore |grep -q -v grep
  PROCESS_1_STATUS=$?
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "ERROR: HIVE METASTORE HAS STOPPED."
    exit 1
  fi
  ps aux |grep hive-server2 |grep -q -v grep
  PROCESS_2_STATUS=$?
  if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "ERROR: HIVE SERVER HAS STOPPED."
    exit 1
  fi

done

