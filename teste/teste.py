from pyspark.sql import SparkSession
import logging

# Set the logging level to WARN
logging.getLogger("py4j").setLevel(logging.ERROR)

# Create a SparkSession
spark = SparkSession.builder \
    .appName("JSON Data Processing") \
    .getOrCreate()

nomes = [ "data-00001-of-00010.json", "data-00002-of-00010.json", "data-00003-of-00010.json",
         "data-00004-of-00010.json", "data-00005-of-00010.json", "data-00006-of-00010.json", "data-00007-of-00010.json",
         "data-00008-of-00010.json", "data-00009-of-00010.json", "data-00000-of-00010.json",]

# Read JSON data from HDFS
for name in nomes:
    json_data = spark.read.json("hdfs://172.19.0.7:9001/test/input/" + name)

# Perform count operation
    record_count = json_data.count()

# Print the count
    print("Number of records of {0}: {1}".format(name, record_count))

# Stop the Spark session
spark.stop()