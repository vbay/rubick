for HOST in test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4 ; do scp -r  /root/tar/sqoop-1.99.7-bin-hadoop200.tar.gz  $HOST:/root/tar  ; done

pdsh -w ^/root/bash/all_host 'source /etc/profile && mkdir /opt/sqoop/ && cd /root/tar && tar -zxf sqoop-1.99.7-bin-hadoop200.tar.gz && mv  sqoop-1.99.7-bin-hadoop200 /opt/sqoop'

vim /etc/profile.d/sqoop2.sh
```sh
#!/bin/sh
# Author:wangxiaolei 王小雷
# Blog: http://blog.csdn.net/dream_an
# Github: https://github.com/vbay
# Date:201901

export SQOOP_HOME=/opt/sqoop/sqoop-1.99.7-bin-hadoop200
export PATH=$SQOOP_HOME/bin:$PATH
export SQOOP_SERVER_EXTRA_LIB=$SQOOP_HOME/extra-lib
```
for HOST in test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4 ; do scp -r  /etc/profile.d/sqoop2.sh  $HOST:/etc/profile.d   ; done

# 更改日志文件地址、更改数据文件地址
```sh
:%s/@LOGDIR@/\/opt\/sqoop\/sqoop-1.99.7-bin-hadoop200\/log\/@LOGDIR@/g

:%s/@BASEDIR@/\/opt\/sqoop\/sqoop-1.99.7-bin-hadoop200\/data\/@BASEDIR@/g
org.apache.sqoop.submission.engine.mapreduce.configuration.directory=/opt/hadoop/hadoop-3.1.1/etc/hadoop
```

for HOST in test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4 ; do scp -r  /opt/sqoop/sqoop-1.99.7-bin-hadoop200/conf/sqoop.properties  $HOST:/opt/sqoop/sqoop-1.99.7-bin-hadoop200/conf   ; done

pdsh -w ^/root/bash/all_hosts 'source /etc/profile && mkdir /opt/sqoop/sqoop-1.99.7-bin-hadoop200/data'


pdsh -w ^/root/bash/all_host 'source /etc/profile && mkdir /opt/sqoop/sqoop-1.99.7-bin-hadoop200/extra-lib'

## 复制第三方依赖
for HOST in test-rubickr0 test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4 ; do scp -r  /root/wxlJar/pub/postgresql-42.2.5.jar  $HOST:/opt/sqoop/sqoop-1.99.7-bin-hadoop200/extra-lib  ; done
for HOST in test-rubickr0 test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4 ; do scp -r  /root/wxlJar/pub/mysql-connector-java-8.0.13.jar  $HOST:/opt/sqoop/sqoop-1.99.7-bin-hadoop200/extra-lib  ; done

<!-- pdsh -w ^/root/bash/all_hosts 'source /etc/profile && mv  /root/derby-10.14.1.0.jar.bac  /opt/hive/apache-hive-3.1.1-bin/lib/derby-10.14.1.0.jar ' -->

 # 移除hive的derby
pdsh -w ^/root/bash/all_hosts 'source /etc/profile && mv /opt/sqoop/sqoop-1.99.7-bin-hadoop200/server/lib/derby-10.8.2.2.jar   /opt/sqoop/sqoop-1.99.7-bin-hadoop200/server/lib/derby-10.8.2.2.jar.bac'


# error 报错 启动时候
```sh
sqoop2-tool upgrade
Caused by: java.lang.SecurityException: sealing violation: package org.apache.derby.impl.jdbc.authentication is sealed
```

 解决 移除hive的derby
pdsh -w ^/root/bash/all_hosts 'source /etc/profile && mv /opt/sqoop/sqoop-1.99.7-bin-hadoop200/server/lib/derby-10.8.2.2.jar   /opt/sqoop/sqoop-1.99.7-bin-hadoop200/server/lib/derby-10.8.2.2.jar.bac'


# server端  在test-rubickr0 初始化 验证 开启
sqoop2-tool upgrade
sqoop2-tool verify
sqoop2-server start


# client端 在test-rubickr0

sqoop2-shell


# 开始job时候报错
修改hadoop core-site.xml



解决
for HOST in test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4 ; do scp -r  /opt/hadoop/hadoop-3.1.1/etc/hadoop/core-site.xml  $HOST:/opt/hadoop/hadoop-3.1.1/etc/hadoop  ; done

## 查看job运行状态或者重新启动job报错
sqoop:000> status job -n tmp_t_homework_students
Exception has occurred during processing command
Exception: org.apache.sqoop.common.SqoopException Message: MAPREDUCE_0003:Can't get RunningJob instance -

sqoop:000> start job -n tmp_t_homework_students
Exception has occurred during processing command
Exception: org.apache.sqoop.common.SqoopException Message: DRIVER_0002:Given job is already running - Job with name tmp_t_homework_students


解决：
root@test-rubickr0:/opt/hadoop/hadoop-3.1.1# bin/mapred --daemon start historyserver



# 问题 container beyond the 'VIRTUAL' memory limit 2.5 GB of 2.1 GB virtual memory used

```xml
<!-- 解决容器虚拟内存不足 container beyond the 'VIRTUAL' memory limit 2.5 GB of 2.1 GB virtual memory used -->
<property>
   <name>yarn.nodemanager.vmem-check-enabled</name>
    <value>false</value>
    <description>Whether virtual memory limits will be enforced for containers</description>
  </property>
 <property>
   <name>yarn.nodemanager.vmem-pmem-ratio</name>
    <value>4</value>
    <description>Ratio between virtual memory to physical memory when setting memory limits for containers</description>
  </property>
```
for HOST in test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4 ; do scp -r  /opt/hadoop/hadoop-3.1.1/etc/hadoop/yarn-site.xml  $HOST:/opt/hadoop/hadoop-3.1.1/etc/hadoop  ; done


# 问题 HDFS snappy压缩出错
sqoop 2  codec not supported SnappyCodec
Caused by: org.apache.parquet.hadoop.codec.CompressionCodecNotSupportedException: codec not supported: org.apache.hadoop.io.compress.SnappyCodec
解决
.
