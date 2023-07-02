from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, count
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
    print("Executando em:" + name)
    data = spark.read.json(spark.sparkContext.wholeTextFiles("hdfs://172.19.0.7:9001/test/input/" + name).values)
    data.show()
    if "mentions" in data.schema.names:
        # Explode the "mentions" field to create key-value pairs
        
        mentions_df = data.select(explode("mentions").alias("mention", "url"))
        print("chegou aqui 2")

        # Count the occurrences of each key-value pair
        mention_counts = mentions_df.groupBy("mention", "url").agg(count("*").alias("count"))
        print("chegou aqui 3")

        # Show the result
        print(mention_counts.show())
    else:
        print("deu ruim")
        lines = data.limit(5).collect()
        for line in lines:
            print(line)
        print(data.schema.names)