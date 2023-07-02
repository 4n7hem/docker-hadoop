DOCKER_NETWORK = dockerhadoop
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
export HADOOP_CLASSPATH := $(shell hdfs classpath)

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
	docker cp .\teste\word_count.py hadoop-jobs:/ 
	docker cp .\teste\mention_count.py hadoop-jobs:/ 
	docker cp .\teste\keyword_count.py hadoop-jobs:/ 

aaaaa:
	docker exec -it namenode hdfs dfs -mkdir /test/
	docker exec -it namenode hdfs dfs -mkdir /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/*.csv /test/input/


