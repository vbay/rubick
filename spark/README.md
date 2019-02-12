# 下载部署
```sh
wget https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz


pdsh -w ^/root/bash/7_hosts 'source /etc/profile &&rm -rf /root/tar-gz'

pdsh -w ^/root/bash/7_hosts 'source /etc/profile && mkdir /root/tar-gz'

for HOST in  rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /root/tar-gz/spark-2.4.0-bin-hadoop2.7.tgz   $HOST:/root/tar-gz ; done



pdsh -w ^/root/bash/all_hosts 'source /etc/profile && cd /root/tar-gz && tar -zxf spark-2.4.0-bin-hadoop2.7.tgz && mv spark-2.4.0-bin-hadoop2.7 /opt/spark/'


vim  /etc/profile.d/spark2.4.sh

pdsh -w ^/root/bash/all_hosts 'source /etc/profile && rm -rf  /etc/profile.d/spark2.3.sh'

for HOST in  rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /etc/profile.d/spark2.4.sh   $HOST:/etc/profile.d/ ; done

for HOST in  rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /opt/spark/spark-2.4.0-bin-hadoop2.7/conf/slaves   $HOST:/opt/spark/spark-2.4.0-bin-hadoop2.7/conf ; done

```



# Spark 优化篇

# Spark 启动优化（先把spark jars上传到spark-jars中，然后再设置spark.yarn.jars 。此为启动优化。否则每次启动都将从本地依赖jar打包为zip然后上传到集群）
```sh
vim metrics.properties(设置这个不管用)
spark.yarn.jars=hdfs://mycluster/spark-jars/*.jar

for HOST in test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4; do scp -r  /opt/spark/spark-2.4.0-bin-hadoop2.7/conf/metrics.properties    $HOST:/opt/spark/spark-2.4.0-bin-hadoop2.7/conf ; done
```

那么另一个vim metrics.properties(设置这个不管用) spark-defaults.conf
```
spark.yarn.jars hdfs://mycluster/spark-jars/*
```


for HOST in rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /opt/spark/spark-2.4.0-bin-hadoop2.7/conf/spark-defaults.conf    $HOST:/opt/spark/spark-2.4.0-bin-hadoop2.7/conf ; done

```sh
hdfs dfs -copyFromLocal jars/* /spark-jars/
```
其他jars
```sh
hdfs dfs -copyFromLocal hive-hbase-handler-3.1.1.jar /spark-jars/ (spark通过hive读取hbase数据所需依赖)
hdfs dfs -copyFromLocal postgresql-42.2.5.jar /spark-jars/

http://central.maven.org/maven2/org/apache/hbase/hbase-shaded-mapreduce/2.1.0/hbase-shaded-mapreduce-2.1.0.jar
hdfs dfs -copyFromLocal hbase-shaded-mapreduce-2.1.0.jar /spark-jars/    （使用spark saveAsNewAPIHadoopDataset API需要该依赖）

```
====

(配置spark 将)

for HOST in rubickr1 rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /opt/spark/spark-2.4.0-bin-hadoop2.7/conf/spark-env.sh    $HOST:/opt/spark/spark-2.4.0-bin-hadoop2.7/conf/ ; done
