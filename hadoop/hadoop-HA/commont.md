<!-- /opt/zookeeper-3.4.10/bin/zkServer.sh start
hdfs namenode -format
/opt/hadoop-2.7.3/sbin/start-dfs.sh
/opt/hadoop-2.7.3/sbin/start-yarn.sh
/opt/hbase-1.3.1/bin/start-hbase.sh
jps

root@rubicksra:/opt/hadoop-2.7.3# jps
3713 SecondaryNameNode
3027 QuorumPeerMain
3883 ResourceManager
4142 Jps
3518 NameNode


/opt/zookeeper-3.4.10/bin/zkServer.sh stop
 -->

HA---

### 8台集群部署
wy-bigdata

# 清空集群
pdsh -w ^all_hosts 'rm -rf /tmp/hadoop* && rm -rf /var/lib/data/hadoop-ha/* && rm -rf /opt/hadoop/hadoop-3.1.1/logs'

for HOST in rubickr1 rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  zookeeper-3.4.13.tar.gz  $HOST:/root/ ; done

pdsh -w ^all_hosts 'source /etc/profile && cd /opt/zookeeper/zookeeper-3.4.13/ && . bin/zkServer.sh start'
pdsh -w ^all_hosts 'source /etc/profile && cd /opt/zookeeper/zookeeper-3.4.13/ && . bin/zkServer.sh status'



# 定义root用户
vim sbin/start-dfs.sh stop-dfs.sh

HDFS_DATANODE_USER=root
HADOOP_SECURE_DN_USER=hdfs
HDFS_NAMENODE_USER=root
HDFS_SECONDARYNAMENODE_USER=root
HDFS_ZKFC_USER=root
HDFS_JOURNALNODE_USER=root

vim hadoop-env.sh
export JAVA_HOME=/opt/java/jdk1.8.0_181/

# Hadoop HA 高可用启动

# 在rubickr1
bin/hdfs --daemon start zkfc

# 启动journalnode(分别在rubickr4-8)
hdfs --daemon stop journalnode
hdfs --daemon start journalnode
cd /opt/hadoop/hadoop-3.1.1/ &&  sbin/hadoop-daemon.sh start journalnode
# format 集群
hdfs namenode -format


hdfs namenode -bootstrapStandby
hdfs --daemon start namenode


## 高可用 resoucemanageer HA
# vim
sudo vim sbin/start-yarn.sh
sudo vim sbin/stop-yarn.sh

YARN_RESOURCEMANAGER_USER=root
YARN_NODEMANAGER_USER=root

# rubickr1上操作，此时在rubickr2已经开通。
sbin/start-yarn.sh
