#!/bin/bash

# Set up ssh keys
rm -f /etc/ssh/*key
ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

# Passwordless ssh
rm -f ~/.ssh/id_dsa
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub > ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

exec /usr/sbin/sshd -D &

# Wait for Zookeeper to Start
echo "Waiting for Zookeeper to start..."
timeout 120 bash -c 'until echo > /dev/tcp/zookeeper/2181; do sleep 0.5; done' &>/dev/null || \
{
        echo -e "###########################################################";
        echo -e "NAMENODE ERROR: Zookeeper did not start within 120 seconds.";
        echo -e "###########################################################";
        exit;
}
echo "Zookeeper Started."

# Start NameNode
nohup hdfs namenode &

# Start Resource Manager
/opt/hadoop/sbin/yarn-daemon.sh --config $YARN_CONF_DIR start resourcemanager

# Start Node Manager
/opt/hadoop/sbin/yarn-daemon.sh --config $YARN_CONF_DIR start nodemanager

# Start Timeline Server
/opt/hadoop/sbin/yarn-daemon.sh --config $YARN_CONF_DIR start timelineserver

# Start History Server
/opt/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver

# Full permissions for hdfs user
hdfs dfs -chown hdfs:supergroup /
hdfs dfs -chmod 777 /
hdfs dfs -chmod 777 /tmp

# Leave safe mode
hadoop dfsadmin -safemode leave

echo
echo "==================================================="
echo "================= NameNode Started ================"
echo "==================================================="
echo

# Run health check on running processes
while sleep 60; do
  ps aux |grep sshd |grep -q -v grep
  PROCESS_1_STATUS=$?
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "NAMENODE ERROR: SSHD HAS STOPPED. "
    exit 1
  fi
  ps aux |grep namenode |grep -q -v grep
  PROCESS_2_STATUS=$?
  if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "NAMENODE ERROR: NAMENODE HAS STOPPED."
    exit 1
  fi
  ps aux |grep resourcemanager |grep -q -v grep
  PROCESS_3_STATUS=$?
  if [ $PROCESS_3_STATUS -ne 0 ]; then
    echo "NAMENODE ERROR: RESOURCE MANAGER HAS STOPPED."
    exit 1
  fi
  ps aux |grep nodemanager |grep -q -v grep
  PROCESS_4_STATUS=$?
  if [ $PROCESS_4_STATUS -ne 0 ]; then
    echo "NAMENODE ERROR: NODE MANAGER HAS STOPPED."
    exit 1
  fi
  ps aux |grep timelineserver |grep -q -v grep
  PROCESS_5_STATUS=$?
  if [ $PROCESS_5_STATUS -ne 0 ]; then
    echo "NAMENODE ERROR: TIMELINE SERVER HAS STOPPED."
    exit 1
  fi
  ps aux |grep historyserver |grep -q -v grep
  PROCESS_6_STATUS=$?
  if [ $PROCESS_6_STATUS -ne 0 ]; then
    echo "NAMENODE ERROR: HISTORY SERVER HAS STOPPED."
    exit 1
  fi
done

