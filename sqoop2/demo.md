
# PostgreSQL -->HDFS 数据导入
```sh
sqoop2-shell

set server --host test-rubickr0 --port 12000 --webapp sqoop  （默认）
set server --host test-rubickr0 --port 12020 --webapp sqoop （更改后）
```
## 创建test-postgresql连接
```sh
sqoop:000> create link --connector generic-jdbc-connector
Creating link for connector with name generic-jdbc-connector
Please fill following values to create new link object
Name: test-postgresql

Database connection

Driver class: org.postgresql.Driver
Connection String: jdbc:postgresql://192.168.88.29:5108/rubicksdb
Username: rubicks
Password: ***********
Fetch Size:
Connection Properties:
There are currently 0 values in the map:
entry#

SQL Dialect

Identifier enclose:
New link was successfully created with validation status OK and name test-postgresql
```
## 创建test-hdfs连接
```sh
sqoop:000> create link --connector hdfs-connector
Creating link for connector with name hdfs-connector
Please fill following values to create new link object
Name: test-hdfs

HDFS cluster

URI: hdfs://mycluster
Conf directory: /opt/hadoop/hadoop-3.1.1/etc/hadoop
Additional configs::
There are currently 0 values in the map:
entry#
New link was successfully created with validation status OK and name test-hdfs
```
## 创建数据导入job
```sh
sqoop:000> create job -f "test-postgresql" -t "test-hdfs"
Creating job for links with from name test-postgresql and to name test-hdfs
0    [main] WARN  org.apache.hadoop.util.NativeCodeLoader  - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Please fill following values to create new job object
Name: tmp_t_homework_students

Database source

Schema name: public
Table name: t_homework_students
SQL statement:
Column names:
There are currently 0 values in the list:
element#
Partition column:
Partition column nullable:
Boundary query:

Incremental read

Check column:
Last value:

Target configuration

Override null value:
Null value:
File format:
  0 : TEXT_FILE
  1 : SEQUENCE_FILE
  2 : PARQUET_FILE
Choose: 2
Compression codec:
  0 : NONE
  1 : DEFAULT
  2 : DEFLATE
  3 : GZIP
  4 : BZIP2
  5 : LZO
  6 : LZ4
  7 : SNAPPY
  8 : CUSTOM
Choose: 3
Custom codec:
Output directory: /tmp/sqoop/t_homework_students
Append mode:

Throttling resources

Extractors:
Loaders:

Classpath configuration

Extra mapper jars:
There are currently 0 values in the list:
element#
New job was successfully created with validation status OK  and name tmp_t_homework_students
```


## 开始任务
start job -name tmp_t_homework_students




# tmp t_homework_students

sqoop:000> create job -f "test-postgresql" -t "test-hdfs"
Creating job for links with from name test-postgresql and to name test-hdfs
Please fill following values to create new job object
Name: tmp_t_homework_students

Database source

Schema name: public
Table name: t_homework_students
SQL statement:
Column names:
There are currently 0 values in the list:
element#
Partition column:
Partition column nullable:
Boundary query:

Incremental read

Check column:
Last value:

Target configuration

Override null value:
Null value:
File format:
  0 : TEXT_FILE
  1 : SEQUENCE_FILE
  2 : PARQUET_FILE
Choose: 2
Compression codec:
  0 : NONE
  1 : DEFAULT
  2 : DEFLATE
  3 : GZIP
  4 : BZIP2
  5 : LZO
  6 : LZ4
  7 : SNAPPY
  8 : CUSTOM
Choose: 3
Custom codec:
Output directory: /tmp/sqoop/t_homework_students
Append mode:

Throttling resources

Extractors:
Loaders:

Classpath configuration

Extra mapper jars:
There are currently 0 values in the list:
element#
New job was successfully created with validation status OK  and name tmp_t_homework_students



# tmp t_homework_student_topics

Name: tmp_t_homework_student_topics

Database source

Schema name: public
Table name: t_homework_student_topics
SQL statement:
Column names:
There are currently 0 values in the list:
element#
Partition column:
Partition column nullable:
Boundary query:

Incremental read

Check column:
Last value:

Target configuration

Override null value:
Null value:
File format:
  0 : TEXT_FILE
  1 : SEQUENCE_FILE
  2 : PARQUET_FILE
Choose: 2
Compression codec:
  0 : NONE
  1 : DEFAULT
  2 : DEFLATE
  3 : GZIP
  4 : BZIP2
  5 : LZO
  6 : LZ4
  7 : SNAPPY
  8 : CUSTOM
Choose: 3
Custom codec:
Error message: Can't be null nor empty
Output directory: /tmp/sqoop/t_homework_student_topics
Append mode:

Throttling resources

Extractors:
Loaders:

Classpath configuration

Extra mapper jars:
There are currently 0 values in the list:
element#
New job was successfully created with validation status OK  and name tmp_t_homework_student_topics


##
.
