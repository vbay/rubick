# 无法启动hbase，报错java.lang.NoClassDefFoundError: org/apache/htrace/SamplerBuilder

 - 解决：pdsh -w ^/root/bash/3host 'cp /opt/hbase/hbase-2.1.1/lib/client-facing-thirdparty/htrace-core-3.1.0-incubating.jar /opt/hbase/hbase-2.1.1/lib/'
pdsh -w ^/root/bash/3host 'source /etc/profile && cd /opt/hbase/hbase-2.1.1/&&  bin/stop-hbase.sh '


# 开启hbase
```sh
cd /opt/hbase/hbase-2.1.1  && bin/start-hbase
```
# 通过NTP同步集群时间
pdsh -w ^/root/bash/all_host 'source /etc/profile && apt install ntp -y'

配置作为时间的服务器
vim /etc/ntp.conf
restrict 192.168.88.1 mask 255.255.255.0 nomodify notrap

server 127.127.22.1                   # ATOM(PPS)
fudge 127.127.22.1 flag3 1            # enable PPS API

其他服务器配置
vi /etc/ntp.conf


#server ntp.n.netease.com
#server 3.cn.pool.ntp.org
#server 1.asia.pool.ntp.org
#server 2.asia.pool.ntp.org
server 192.168.88.94
#pool ntp.ubuntu.com


2 重新启动
service ntp restart
查看
ntpq -p
