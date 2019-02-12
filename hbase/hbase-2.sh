#!/bin/sh
# author:wangxiaolei
# create: 201810
# update: 201811
# path: /etc/profile.d

export HBASE_HOME=/opt/hbase/hbase-2.1.1
export PATH=$HBASE_HOME/bin:$PATH
export HBASE_CONF_DIR=$HBASE_HOME/conf
export HBASE_CLASSPATH=$HBASE_HOME/lib
