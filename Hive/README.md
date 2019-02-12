# Hive 应用
hive 部署是单机的，元数据部署方式有（3.0+）内嵌模式（Derby）、远程模式。其中远程模式生产环境（推荐）。内嵌模式一般用于开发测试。
## hive 安装
```sh
wget https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-3.1.1/apache-hive-3.1.1-bin.tar.gz
```


解压、放置到对应文件夹

for HOST in  rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /root/tar-gz/apache-hive-3.1.1-bin.tar.gz   $HOST:/root/tar-gz/ ; done

pdsh -w ^/root/bash/all_hosts 'source /etc/profile && cd /root/tar-gz/ && tar -zxf apache-hive-3.1.1-bin.tar.gz && mkdir /opt/hive/ && mv apache-hive-3.1.1-bin /opt/hive/  '


# 修改hive-default.xml.temp 为 hive-site.xml （可覆盖默认配置）

特殊，因为使用postgresql作为metadata存储，所以讲配置项 ```hive.metastore.try.direct.sql.ddl``` 设置为false

2. 创建hive postgresql数据库（元数据）
sudo -u postgres psql postgres
postgres=# CREATE ROLE hive WITH PASSWORD 'hive*20181206' LOGIN ;
CREATE ROLE
postgres=# CREATE DATABASE metastore_db OWNER 'hive';
CREATE DATABASE

2. 修改数据库连接配置项
1.处修改，添加
```xml
<property>
  <name>spark.yarn.jars</name>
  <value>hdfs://mycluster/spark-jars/*</value>
</property>
<property>
  <name>system:java.io.tmpdir</name>
  <value>/tmp/hive/java</value>
</property>
<property>
  <name>system:user.name</name>
  <value>${user.name}</value>
</property>
```
2.处修改
``` xml
javax.jdo.option.ConnectionURL
```
 值为注意端口号这里为5108 默认为5432
```xml
jdbc:postgresql://192.168.88.36:5108/metastore_db```
```
3.处修改
```
javax.jdo.option.ConnectionDriverName
```
值为
```xml
org.postgresql.Driver
```
4.处修改
```xml
javax.jdo.option.ConnectionPassword
```
5.处修改
```xml
javax.jdo.option.ConnectionUserName
```
值为
```xml
<property>
  <name>javax.jdo.option.ConnectionUserName</name>
  <value>hive</value>
  <description>Username to use against metastore database</description>
</property>
```
6.处修改
```xml
<property>
  <name>hive.metastore.uris</name>
  <value>thrift://192.168.88.15:9083,thrift://192.168.88.16:9083</value>
  <description>Thrift URI for the remote metastore. Used by metastore client to connect to remote metastore.</description>
</property>
```

for HOST in  rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /opt/hive/apache-hive-3.1.1-bin/conf/hive-site.xml   $HOST:/opt/hive/apache-hive-3.1.1-bin/conf/ ; done



(配置Spark，将hive-site.mxl copy to spark/conf directory)

for HOST in rubickr1 rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /opt/hive/apache-hive-3.1.1-bin/conf/hive-site.xml    $HOST:/opt/spark/spark-2.4.0-bin-hadoop2.7/conf/ ; done

(配置spark 将)

for HOST in rubickr1 rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /opt/spark/spark-2.4.0-bin-hadoop2.7/conf/spark-env.sh    $HOST:/opt/spark/spark-2.4.0-bin-hadoop2.7/conf/ ; done

# 创建hive环境变量
vim /etc/profile.d/hive3.sh
for HOST in trubickr1 rubickr2 rubickr3 rubickr4 rubickr5 rubickr6 rubickr7 rubickr8; do scp -r  /etc/profile.d/hive3.sh    $HOST:/etc/profile.d/ ; done

# 配置postgresql数据库可以远程连接
vim /etc/postgresql/11/main/postgresql.conf
```conf
listen_addresses = '*'
port = 5108
```


vim /etc/postgresql/11/main/pg_hba.conf

```config
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
host    all             all             0.0.0.0/0               md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
```
# 在test-rubickr0上初始化hive(postgres数据库) 遇到问题 $Q1 $Q2

schematool --dbType postgres --initSchema


# 在test-rubickr0和test-rubickr1 上分别启动 metastore 服务(正常的日志与错误日志分开放)
mkdir /opt/hive/apache-hive-3.1.1-bin/log
cd  /opt/hive/apache-hive-3.1.1-bin/log
nohup  hive --service metastore > metastore.out 2>metastore.err &




# 创建为外部表


CREATE EXTERNAL TABLE hbase_table_2(id int,aa string,bb string)STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
 WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf:a,cf:b") TBLPROPERTIES("hbase.table.name" = "tmp1");




$Q1:初始化失败  Class path contains multiple SLF4J bindings.
```conf
Ensures commands with OVERWRITE (such as INSERT OVERWRITE) acquire Exclusive locks for&#8;transactional tables.  This ensures that inserts (w/o overwrite) running concurrently
      are not hidden by the INSERT OVERWRITE.
```
解决：把中间的奇怪符号干掉 ```&#8;```


$Q2：初始化失败 *** schemaTool failed ***

```log
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
Metastore connection URL:	 jdbc:postgresql://192.168.88.36:5108/metastore_db?ssl=true
Metastore Connection Driver :	 org.postgresql.Driver
Metastore connection User:	 APP
org.apache.hadoop.hive.metastore.HiveMetaException: Failed to get schema version.
Underlying cause: org.postgresql.util.PSQLException : SSL error: sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
SQL Error code: 0
Use --verbose for detailed stacktrace.
*** schemaTool failed ***
```

jdbc:postgresql://192.168.88.36:5108/metastore_db 干掉后边的 ```?ssl=true```





。
