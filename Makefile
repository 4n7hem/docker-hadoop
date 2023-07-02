DOCKER_NETWORK = dockerhadoop
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
export HADOOP_CLASSPATH := $(shell hdfs classpath)

build:
	docker build -t bde2020/hadoop-base:$(current_branch) ./base
	docker build -t bde2020/hadoop-namenode:$(current_branch) ./namenode
	docker build -t bde2020/hadoop-datanode:$(current_branch) ./datanode
	docker build -t bde2020/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t bde2020/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t bde2020/hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t bde2020/hadoop-submit:$(current_branch) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base: hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base hdfs dfs -rm -r /input

load-data:
	docker cp D:\dados\. namenode:/tmp/	
	docker exec -it namenode hdfs dfs -mkdir /test/
	docker exec -it namenode hdfs dfs -mkdir /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/*.csv /test/input/
	
access-namenode:
	docker exec -it namenode /bin/bash

config-test:
	docker build -t hadoop-jobs ./teste

start-jobs:
	docker run --network ${DOCKER_NETWORK} --name hadoop-jobs hadoop-jobs

load-tests:	
	docker cp .\teste\teste.py hadoop-jobs:/ 
	docker cp .\teste\teste2.py hadoop-jobs:/ 

aaaaa:
	docker exec -it namenode hdfs dfs -mkdir /test/
	docker exec -it namenode hdfs dfs -mkdir /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/*.csv /test/input/

#load-test:
#Passos para compilar e rodar um job:
# Dentro do bash do namenode, fazer:
# cd tmp
# hdfs classpath
# export HADOOP_CLASSPATH=$(o retorno do comando acima)
# javac -classpath $HADOOP_CLASSPATH -d ./classes/ ./URLCountJob.java
# jar -cvf URLCountJob.jar -C ./classes .
# hadoop jar URLCountJob.jar URLCountJob /test/input/* /test/output
# Agora é fazer o Makefile executar tudo isso
#	docker exec -it namenode export HADOOP_CLASSPATH=$(hdfs classpath)
#	docker cp ./teste/URLCountJob.java namenode:/tmp/
