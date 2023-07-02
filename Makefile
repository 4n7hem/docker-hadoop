DOCKER_NETWORK = dockerhadoop
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
export HADOOP_CLASSPATH := $(shell hdfs classpath)

load-data:
	docker cp D:\dados\. namenode:/tmp/	
	docker exec -it namenode hdfs dfs -mkdir /test/
	docker exec -it namenode hdfs dfs -mkdir /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00000-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00001-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00002-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00003-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00004-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00005-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00006-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00007-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00008-of-00010.csv /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/data-00009-of-00010.csv /test/input/
	
access-jobs:
	docker exec -it hadoop-jobs bash

config-test:
	docker build -t hadoop-jobs ./teste

load-tests:	
	docker cp .\teste\word_count.py hadoop-jobs:/ 
	docker cp .\teste\mention_count.py hadoop-jobs:/ 
	docker cp .\teste\keyword_count.py hadoop-jobs:/ 

aaaaa:
	docker exec -it namenode hdfs dfs -mkdir /test/
	docker exec -it namenode hdfs dfs -mkdir /test/input/
	docker exec -it namenode hdfs dfs -copyFromLocal /tmp/*.csv /test/input/


