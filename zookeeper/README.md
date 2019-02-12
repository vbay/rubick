```sh
for HOST in rubickr1  test-rubickr0 test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4; do `echo ${HOST: -1} > myid` && scp myid $HOST:/var/lib/data/zookeeper/  ; done

for HOST in  test-rubickr0 test-rubickr1 test-rubickr2 test-rubickr3 test-rubickr4; do `echo ` expr ${HOST: -1} + 1   > myid` ` && scp myid $HOST:/var/lib/data/zookeeper/  ; done

pdsh -w ^/root/bash/all_hosts 'source /etc/profile &&  rm -rf /var/lib/data/zookeeper/* & '

pdsh -w ^/root/bash/all_hosts 'source /etc/profile &&  cd /opt/zookeeper/zookeeper-3.4.13/ && bin/zkServer.sh status'
pdsh -w ^/root/bash/all_hosts 'source /etc/profile && cd /opt/zookeeper/zookeeper-3.4.13/ && bin/zkServer.sh start'
pdsh -w ^/root/bash/all_hosts 'source /etc/profile && cd /opt/zookeeper/zookeeper-3.4.13/ && bin/zkServer.sh stop'
```
