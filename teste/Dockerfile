FROM python:3.9-slim-buster

# Install OpenJDK for running PySpark
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/*

# Install required Python packages
RUN pip install pyspark

# Set environment variables
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3

# Keep the container running
CMD tail -f /dev/null
