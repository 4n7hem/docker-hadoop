from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col
from pyspark.sql.types import StructType
import logging
import time

# Set the logging level to WARN
logging.getLogger("py4j").setLevel(logging.ERROR)
logging.getLogger("org.apache.spark.sql.execution.RowBasedKeyValueBatch").setLevel(logging.ERROR)

start = time.time()

# Create a SparkSession
spark = SparkSession.builder \
    .appName("CSV Data Processing") \
    .getOrCreate()

nomes = [ "data-00001-of-00010.csv", "data-00002-of-00010.csv", "data-00003-of-00010.csv",
         "data-00004-of-00010.csv", "data-00005-of-00010.csv", "data-00006-of-00010.csv", "data-00007-of-00010.csv",
         "data-00008-of-00010.csv", "data-00009-of-00010.csv", "data-00000-of-00010.csv",]

nomes = ["hdfs://namenode.dockerhadoop:9001/test/input/" + s for s in nomes]

# Initialize an empty DataFrame for storing the total mention counts
total_mention_counts = None

# Read csv data from HDFS
df = spark.read.csv(nomes, header=True)

# Split the 'Mentions' column by comma and explode the array
mentions_col = col("Tokens").cast("string").alias("Tokens")
exploded_mentions = df.withColumn("Tokens", split(mentions_col, ","))

# Explode the array of mentions and calculate the frequencies
mention_counts = exploded_mentions.select(explode("Tokens").alias("Tokens")).groupBy("Tokens").count()

# Show the resulting mention frequencies
# mention_counts.show()

# Join the current mention_counts with the total_mention_counts if it exists
if total_mention_counts is not None:
    total_mention_counts = total_mention_counts.unionAll(mention_counts)
else:
    total_mention_counts = mention_counts


# Sum the mention counts from all the DataFrames
total_mention_counts = total_mention_counts.groupBy("Tokens").sum("count")

total_mention_counts.write.csv("saida", header=True, mode="overwrite")

# Merge the output files into a single file
output_file = "saida" + "/part-*.csv"
combined_output_file = "saida" + "/combined_output"
total_mention_counts.sparkSession \
    .read \
    .option("header", "true") \
    .csv(output_file) \
    .coalesce(1) \
    .write \
    .option("header", "true") \
    .csv(combined_output_file)


# Stop the SparkSession
spark.stop()

end = time.time()

print("Tempo de execução: {0:.2f} segundos".format(end-start))