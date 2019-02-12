# 部署

多节点多broker部署（多台节点，每个节点上一个broker）
## 下载部署
```sh
for HOST in test-rubickr0 test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4; do scp -r  /root/tar/kafka_2.12-2.1.0.tgz    $HOST:/root/tar ; done
pdsh -w ^/root/bash/all_host '  mkdir /opt/kafka/ && cd /root/tar  && tar -zxf  kafka_2.12-2.1.0.tgz '
pdsh -w ^/root/bash/all_host 'mv /root/tar/kafka_2.12-2.1.0  /opt/kafka/ '
```
## 修改配置文件
``` sh
vim /opt/kafka/kafka_2.12-2.1.0/config/server.properties
```
每个broker.id都不同需要唯一，如节点一上是0，节点二上是1..
```properties
broker.id=0
zookeeper.connect=test-rubickr0:2181,test-rubickr1:2181,test-rubickr2:2181,test-rubickr3:2181,test-rubickr4:2181
```

## 启动

```sh
pdsh -w ^/root/bash/all_host 'source /etc/profile && cd /opt/kafka/kafka_2.12-2.1.0 &&  bin/kafka-server-start.sh -daemon config/server.properties'
```

## 运行jar

```sh
bin/kafka-topics.sh --create --zookeeper test-rubickr0:2181,test-rubickr1:2181,test-rubickr2:2181,test-rubickr3:2181,test-rubickr4:2181 --replication-factor 1 --partitions 1 --topic temp-1

bin/kafka-topics.sh --list --zookeeper localhost:2181
bin/kafka-topics.sh --list --zookeeper test-rubickr0:2181,test-rubickr1:2181,test-rubickr2:2181,test-rubickr3:2181,test-rubickr4:2181
```


```sh
 bin/kafka-topics.sh --list --zookeeper localhost:2181
 bin/kafka-topics.sh --list --zookeeper test-rubickr0:2181,test-rubickr1:2181,test-rubickr2:2181,test-rubickr3:2181,test-rubickr4:2181
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic temp-1 --from-beginning
bin/kafka-console-consumer.sh --bootstrap-server test-rubickr0:2181,test-rubickr1:2181,test-rubickr2:2181,test-rubickr3:2181,test-rubickr4:2181 --topic temp-1 --from-beginning
```


bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic temp-1 --from-beginning
