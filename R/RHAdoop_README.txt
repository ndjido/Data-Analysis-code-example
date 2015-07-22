#++++++++++++++++++++++++++++++++++++++++
# RHadoop install process : centos 6.5
#++++++++++++++++++++++++++++++++++++++++

rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

yum install -y R curl-devel

export HADOOP_CMD=/usr/hdp/2.2.0.0-2041/hadoop/bin/hadoop
export HADOOP_STREAMING=/usr/hdp/2.2.0.0-2041/hadoop-mapreduce/hadoop-streaming.jar


rhive.init(hiveHome=NULL, hiveLib=NULL, hadoopHome=NULL, hadoopConf=NULL,
  hadoopLib=NULL, verbose=FALSE)


Sys.setenv(HADOOP_CMD="/usr/hdp/2.2.0.0-2041/hadoop/bin/hadoop")

Sys.setenv(HADOOP_STREAMING="/usr/hdp/2.2.0.0-2041/hadoop-mapreduce/hadoop-streaming.jar")

Sys.setenv(HADOOP_HOME="/usr/hdp/2.2.0.0-2041/hadoop")

Sys.setenv(HADOOP_HOME="/usr/hdp/current/hadoop-client")


Sys.setenv(HADOOP_CMD="/usr/hdp/current/hadoop-client/bin/hadoop")


Sys.setenv(HADOOP_LIB="/usr/hdp/2.2.0.0-2041/hadoop/lib")

Sys.setenv(HADOOP_HIVE="/usr/hdp/2.2.0.0-2041/hive")

Sys.setenv(HADOOP_CONF_DIR="/usr/hdp/current/hadoop-client/conf/")

#Connetion to Hive from R

rhive.init(hadoopConf="", verbose=TRUE)

rhive.env(ALL=TRUE)

rhive.connect(host="keolis-slave1.cloudapp.net", hiveServer2=TRUE, defaultFS="hdfs://keolis-master1.cloudapp.net:8020/user/hypercube")






