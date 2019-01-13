#!/bin/bash

# Wait for Zookeeper to Start
echo "Waiting for Zookeeper to start..."
timeout 120 bash -c 'until echo > /dev/tcp/zookeeper/2181; do sleep 0.5; done' &>/dev/null || \
{
        echo -e "#########################################################";
        echo -e "IMPALA ERROR: Zookeeper did not start within 120 seconds.";
        echo -e "#########################################################";
        exit;
}
echo "Zookeeper Started."

# Wait for Postgres to Start
echo "Waiting for PostgreSQL to start..."
timeout 120 bash -c 'until echo > /dev/tcp/postgres/5432; do sleep 0.5; done' &>/dev/null || \
{
        echo -e "##########################################################";
        echo -e "IMPALA ERROR: PostgreSQL did not start within 120 seconds.";
        echo -e "##########################################################";
        exit;
}
echo "PostgreSQL Started."

# Wait for NameNode to Start
echo "Waiting for NameNode to start..."
timeout 120 bash -c 'until echo > /dev/tcp/namenode/8020; do sleep 0.5; done' &>/dev/null || \
{
        echo -e "###############################################################";
        echo -e "IMPALA ERROR: Hadoop NameNode did not start within 120 seconds.";
        echo -e "###############################################################";
        exit;
}
echo "NameNode Started."

/etc/init.d/impala-state-store start
/etc/init.d/impala-catalog start
/etc/init.d/impala-server start

echo
echo "===================================================="
echo "================== Impala Started =================="
echo "===================================================="
echo

# Run health check on running processes
while sleep 60; do
  ps aux |grep statestored |grep -q -v grep
  PROCESS_1_STATUS=$?
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "ERROR: IMPALA STATESTORE HAS STOPPED."
    exit 1
  fi
  ps aux |grep catalogd |grep -q -v grep
  PROCESS_2_STATUS=$?
  if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "ERROR: IMPALA CATALOG HAS STOPPED."
    exit 1
  fi
  ps aux |grep impalad |grep -q -v grep
  PROCESS_3_STATUS=$?
  if [ $PROCESS_3_STATUS -ne 0 ]; then
    echo "ERROR: IMPALA SERVER HAS STOPPED."
    exit 1
  fi

done
