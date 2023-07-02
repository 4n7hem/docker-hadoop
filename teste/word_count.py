from pyspark.sql import SparkSession
import logging
import time

# Set the logging level to WARN
logging.getLogger("py4j").setLevel(logging.ERROR)

start = time.time()
# Create a SparkSession
spark = SparkSession.builder \
    .appName("csv Data Processing") \
    .getOrCreate()

nomes = [ "data-00001-of-00010.csv", "data-00002-of-00010.csv", "data-00003-of-00010.csv",
         "data-00004-of-00010.csv", "data-00005-of-00010.csv", "data-00006-of-00010.csv", "data-00007-of-00010.csv",
         "data-00008-of-00010.csv", "data-00009-of-00010.csv", "data-00000-of-00010.csv",]

# Read csv data from HDFS
for name in nomes:
    csv_data = spark.read.csv("hdfs://namenode.dockerhadoop:9001/test/input/" + name, header=True)

# Perform count operation
    record_count = csv_data.count()

# Print the count
    print("Number of records of {0}: {1}".format(name, record_count))

# Stop the Spark session
spark.stop()
end = time.time()

print("Tempo de execução: {0:.2f} segundos".format(end-start))