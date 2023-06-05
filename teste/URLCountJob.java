import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class URLCountJob {

    public static class URLCountMapper extends Mapper<Object, Text, Text, IntWritable> {

        private final static IntWritable ONE = new IntWritable(1);
        private Text word = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            // Parse the JSON data and extract the URL field
            String line = value.toString();
            String url = line.split("\"URL\":")[1].split(",")[0].trim();
            word.set(url);

            // Emit the URL as the key and a count of 1 as the value
            context.write(word, ONE);
        }
    }

    public static class URLCountReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
            int sum = 0;

            // Sum up the counts for each URL
            for (IntWritable value : values) {
                sum += value.get();
            }

            result.set(sum);

            // Emit the URL and its count
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "URL Count");
        job.setJarByClass(URLCountJob.class);
        job.setMapperClass(URLCountMapper.class);
        job.setCombinerClass(URLCountReducer.class);
        job.setReducerClass(URLCountReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path("hdfs://localhost:9000/test/input"));
        FileOutputFormat.setOutputPath(job, new Path("hdfs://localhost:9000/test/output"));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
