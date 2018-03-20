'''
Create RDD from file 
'''
#Read Shakespeare text from HDFS
#The textFile() method reads the file into a Resilient Distributed Dataset (RDD) with each line in the file being an element in the RDD collection.
#sc stands for spark context
lines = sc.textFile("hdfs:/user/cloudera/words.txt")
lines.count()

#Take the first num elements of the RDD
lines.take(5)

#Split each line into words
#after the flatMap transformation, the lines RDD will removed until specifically cached
words = lines.flatMap(lambda line : line.split(" "))

#Create tuples for each word with an initial count of 1
tuples = words.map(lambda word : (word, 1))

#Sum all the counts in the tuples for each word into a new RDD counts
#The reduceByKey() method calls the lambda expression for all the tuples with the same word. The lambda expression has two arguments, a and b, which are the count values in two tuples.
counts = tuples.reduceByKey(lambda a, b: (a + b))

#Write word counts to text file in HDFS
#The coalesce() method combines all the RDD partitions into num partitions. Since we want a single output file, we use 1 here.
counts.coalesce(1).saveAsTextFile('hdfs:/user/cloudera/wordcount/outputDir')

#To view the result file: copy the file from HDFS to local




'''
Create RDD using existing obj

- Spark works with partition; MapReduce works directly with element
'''
#Distribute a local Python collection to form an RDD
#Number specifies the num of partitions
ws = sc.parallelize(["big", "data"], 2)

#Return a list that contains all of the elements in this RDD.
ws.collect()




'''
Spark Core: Transformation

- Transformations are lazy. They are not executed until an "action"
'''
#--map
#apply function to each element (every element in every partition) of RDD
def lower(line): return line.lower()
lower_text_RDD = text_RDD.map(lower)


#--flatMap
#map then flatten output


#--filter
#Keep only elements where function is true
def starts_with_a(word): return word.lower.startswith("a")
words_RDD.filter(starts_with_a).collect()


#--coalesce
#Reduce the number of partition (more efficient if each partition size is small)


#--groupByKey
#Works on tuple
#(K, V) pairs -> (K, list of all V)


#--reduceByKey
#See above example




'''
Spark Core: Action
'''
#--collect
#--take
#--saveAsTextFile
#See above


#--reduce
#Aggregate elements with func (takes 2 elements, returns 1)




'''
Spark SQL

- Query sources or acquire from existing obj
- Create a DataFrame
- Convert into RDD
'''
#--Create a SQL context
from pyspark.sql import SQLContext
sqlContext = SQLContext(sc)


#--Read from file and show
df = sqlContext.read.json("/filename.json")
df.show()

#--Create table from existing obj
lines = sc.textFile("filename.txt")
cols = lines.map(lambda l: l.split(", "))
data = cols.map(lambda p: Row(name=p[0], zip=int(p[1])))

#Create
df = sqlContext.createDataFrame(data)

#Register as a table
df.registerTempTable("tb")


#--Run SQL
output = sqlContext.sql("SELECT * FROM tb")


#--Other df operations
df.printScheme()
df.select("X" + 5).show()
df.filter(df["height"] > 4).show()
df.groupby("zip").count().show()


#--Aggregated operations
from pyspark.sql.functions import *
df.select(mean("ishit"), sum("ishit")).show()


#--Join
merge = df.join(df2, 'userid')




'''
Spark Streaming

- Create Discretize Stream (micro batches) for operation
- Batch length ia based on time
- Batches can be aggregated into windows, so to perform sliding window operations
'''
from pysprk.streaming import StreamingContext
ssc = StreamingContext(sc, 1) #Batch interval 1 sec
lines = ssc.socketTextStream("rtd.hpwren.ucsd.edu", 12028) #12028 port

vals = lines.flatMap(parse)

#Create sliding window
window = vals.window(10, 5) #Combine 10 batches and move by 5 batches

#Analysis for each window
window.foreachRDD(lambda rdd: stats(rdd))

#Start and stop
scc.start()
scc.stop()




'''
Spark MLLib

- ML
- Stat
- Utility. e.g. d reduction
'''
#--Compute column summary stats
from pyspark.mllib.stat import Statistics
dataMatrix = sc.parallelize([1, 1, 2], [2, 2, 3])

summary = Statistics.colStats(dataMatrix)
print(summary.mean())
print(summary.variance())
print(summary.numNonzeros())


#--Decision tree
from pyspark.mllib.tree import DecisionTree, DecisionTreeModel
from pyspark.mllib.util import MLUtils
data = sc.textFile("data.txt")

model = DecisionTree.trainClassifier(parsedData, numClasses=2)
print(model.toDebugString())

model.save(sc, "decisionTreeModel")


#--K-mean
from pyspark.mllib.clustering import KMeans, KMeansModel
from numpy import array
data = sc.textFile("data.txt")
parsedData = data.map(lambda line: array([float(x) for x in line.split(", ")]))

clusters = Kmeans.train(parsedData, k=3)
print(cluster.centers)
