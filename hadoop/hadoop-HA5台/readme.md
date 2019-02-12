# 定义root用户
vim sbin/start-dfs.sh stop-dfs.sh

HDFS_DATANODE_USER=root
HADOOP_SECURE_DN_USER=hdfs
HDFS_NAMENODE_USER=root
HDFS_SECONDARYNAMENODE_USER=root
HDFS_ZKFC_USER=root
HDFS_JOURNALNODE_USER=root

vim hadoop-env.sh
export JAVA_HOME=/opt/java/jdk1.8.0_191

vim start-yarn.sh stop-yarn.sh
YARN_RESOURCEMANAGER_USER=root
YARN_NODEMANAGER_USER=root

########  初次部署  ##########
# Hadoop HA 高可用启动
# 开启Zookeeper

pdsh -w ^/root/bash/all_host 'source /etc/profile && cd /opt/zookeeper/zookeeper-3.4.13/ && ./bin/zkServer.sh start'
pdsh -w ^/root/bash/all_host 'source /etc/profile && cd /opt/zookeeper/zookeeper-3.4.13/ && ./bin/zkServer.sh status'

###首次初始化集群 HDFS
# 在第一个节点上开启HDFS（namenode1）
cd /opt/hadoop/hadoop-3.1.1 &&  sbin/hadoop-daemons.sh start journalnode
hdfs namenode -format
cd /opt/hadoop/hadoop-3.1.1 && bin/hdfs zkfc -formatZK
cd /opt/hadoop/hadoop-3.1.1 && sbin/start-dfs.sh


#在节点2同步namenode数据然后开启(namenode2)
cd /opt/hadoop/hadoop-3.1.1 &&  bin/hdfs namenode -bootstrapStandby
hdfs --daemon start namenode

#测试HDFS
hdfs dfs -put /etc/profile /profile
hdfs dfs -ls /
###




## 高可用 resoucemanageer HA
# vim
sudo vim sbin/start-yarn.sh sbin/stop-yarn.sh

YARN_RESOURCEMANAGER_USER=root
YARN_NODEMANAGER_USER=root

# 开启yarn
cd /opt/hadoop/hadoop-3.1.1 && sbin/start-yarn.sh

# 验证yarn
hdfs dfs -mkdir /tmp/test/
hdfs dfs -copyFromLocal hadoop-root-namenode-test-rubickr0.log /tmp/test/
 hadoop dfs -copyFromLocal hadoop-root-namenode-test-rubickr0.log /tmp/test/
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.1.jar wordcount /tmp/test/hadoop-root-namenode-test-rubickr0.log /tmp/test/out
# 查看
yarn rmadmin -getServiceState rm1
yarn rmadmin -getServiceState rm2

########  /初次部署  ##########

##  清除操作

pdsh -w ^/root/bash/all_host 'source /etc/profile && cd /opt/zookeeper/zookeeper-3.4.13/ && bin/zkServer.sh stop'

pdsh -w ^/root/bash/all_host 'source /etc/profile &&  rm -rf /var/lib/data/zookeeper/* & '

for HOST in  test-rubickr0 test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4; do `echo ` expr ${HOST: -1} + 1   > myid` ` && scp myid $HOST:/var/lib/data/zookeeper/  ; done


cd /opt/hadoop/hadoop-3.1.1 && sbin/stop-dfs.sh

pdsh -w ^/root/bash/all_host 'source /etc/profile &&  rm -rf /tmp/hadoop* && rm -rf /var/lib/data/hadoop-ha/*'


cd /opt/hadoop/hadoop-3.1.1 && sbin/stop-yarn.sh

# 普通开启集群

cd /opt/hadoop/hadoop-3.1.1 && sbin/start-dfs.sh

cd /opt/hadoop/hadoop-3.1.1 && sbin/start-yarn.sh






.
