'''
------------------------------------------------------------------
Local (Red Hat)
------------------------------------------------------------------
'''
cd Downloads
cd ..
cd $HOME/Downloads
ls

#Examine file content (in CMD)
more local.txt

#Unzip file
unzip -o big-data-2.zip

#Execute file
./setup.sh #The './' is necessary

#Execute py function (file)
./json_schema.py twitter.json | more #'|' is used to pipe the result

#View image file
#eog stands for Eye of Gnome and is a common image viewer on Linux systems
eog Australia.jpg

#Download file from web
wget http://archive.apache.org/dist/lucene/java/5.5.0/lucene-5.5.0.tgz


#--'tar' files
#'tar' is a archive file (a file collection) in Linux
#'tar.gz' and 'tar.bz2' is a compression of tar
#The tar is most widely used command to create compressed archive files and that can be moved easily from one disk to another disk or machine to machine
#Create 'tar' file
tar cvzf MyImages-14-09-12.tgz /home/MyImages

#Untar (and decompress) 'tar' file
tar -xvf thumbnails-14-09-12.tar.gz








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