#!/bin/sh
# author:wangxiaolei
# path: /etc/profile.d/
# create:201809
# update:201809

export HADOOP_HOME="/opt/hadoop/hadoop-3.1.1"
export PATH="$HADOOP_HOME/bin:$PATH"
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
# export LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$LD_LIBRARY_PATH
