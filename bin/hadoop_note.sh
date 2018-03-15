'''
------------------------------------------------------------------
Local (Red Hat)
------------------------------------------------------------------
'''
cd Downloads
ls

#Examine file content (in CMD)
more local.txt








'''
------------------------------------------------------------------
Hadoop
------------------------------------------------------------------
'''
#Examine file list
hadoop fs -ls
hadoop fs -ls out #Examine files in the out folder

#Copy from local to HDFS
hadoop fs -copyFromLocal t8.shakespeare.txt

#Copy file in HDFS
hadoop fs -cp t8.shakespeare.txt words.txt

#Copy from HDFS to local
hadoop fs -copyToLocal words.txt

#Remove file in HDFS
hadoop fs -rm t8.shakespeare.txt

#Remove folder in HDFS
hadoop fs -rm -r out/


#--Hadoop example programs
#Example program list
hadoop jar /usr/jars/hadoop-examples.jar

#Get program usage
hadoop jar /usr/jars/hadoop-examples.jar wordcount

#Run program (output in the "out" folder)
hadoop jar /usr/jars/hadoop-examples.jar wordcount words.txt out