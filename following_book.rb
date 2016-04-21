# Intro to create, put, get
create 'wiki', 'text'
put 'wiki', 'Home', 'text:', 'Welcome to the wiki!'
get 'wiki', 'Home', 'text:'

# Intro to altering a table
disable 'wiki'
alter 'wiki', { NAME => 'text', VERSIONS => org.apache.hadoop.hbase.HConstants::ALL_VERSIONS }
alter 'wiki', { NAME => 'revision', VERSIONS => org.apache.hadoop.hbase.HConstants::ALL_VERSIONS }
enable 'wiki'

exit

# hbase shell put_multiple_columns.rb


# Check script results
get 'wiki', 'Home'

############# DELETE AND SCAN #################
=begin 

To delete a single column value, e.g.: 
delete 'wiki', 'Home', 'revision:author'
or
wiki.delete 'Home', 'revision:author'

More generally:
delete 'table', 'row', 'columnFamily:column'

To delete a row, e.g.:
deleteall 'wiki', 'Home'

To view everything in a table:
scan 'wiki'

To see tables:
list

=end
################################################

# Before running import_from_wikipedia.rb
alter 'wiki', {NAME=>'text', COMPRESSION=>'GZ', BLOOMFILTER=>'ROW'}


############ WIKI DUMP ###############
=begin 

To download wiki and run import_from_wikipedia.rb:
curl <dump_url> | bzcat | ${HBASE_HOME}/bin/hbase shell import_from_wikipedia.rb
	
Note that you should replace <dump_url> with the URL of a WikiMedia Founda-
tion dump file of some kind. 2 You should use [project]-latest-pages-articles.xml.bz2
for either the English Wikipedia (~6GB) 3 or the English Wiktionary (~185MB).
These files contain all the most recent revisions of pages in the Main namespace.
That is, they omit user pages, discussion pages, and so on.

e.g.: curl https://dumps.wikimedia.org/enwiki/20160305/enwiki-20160305-pages-articles-multistream.xml.bz2 | bzcat | ${HBASE_HOME}/bin/hbase shell import_from_wikipedia.rb

############## DISK USAGE ###############

To see how much space the data is taking up:
navigate to hbase.rootdir location (e.g. ~/hbase-data/)

du -h

The lines starting with /wiki describe the space usage for the wiki
table. The long-named subdirectory 517496fecabb7d16af7573fc37257905 represents
an individual region (the only region so far). Under that, the directories /text
and /revision correspond to the text and revision column families, respectively.
Finally, the last line sums up all these values, telling us that HBase is using
365MB of disk space.

One more thing. The first two lines at the top of output, starting with /.logs ,
show us the space used by the write-ahead log (WAL) files. HBase uses write-
ahead logging to provide protection against node failures. This is a fairly
typical disaster recovery technique. For instance, write-ahead logging in file
systems is called journaling. In HBase, logs are appended to the WAL before
any edit operations (put and increment) are persisted to disk.

For performance reasons, edits are not necessarily written to disk immediately.
The system does much better when I/O is buffered and written to disk in
chunks. If the region server responsible for the affected region were to crash
during this limbo period, HBase would use the WAL to determine which
operations were successful and take corrective action.

Writing to the WAL is optional and enabled by default. Edit classes like Put
and Increment have a setter method called setWriteToWAL() that can be used to
exclude the operation from being written to the WAL. Generally you’ll want
to keep the default option, but in some instances it might make sense to
change it. For example, if you’re running an import job that you can rerun
any time, like our Wikipedia import script, you might want to take the perfor-
mance benefit of disabling WAL writes over the disaster recovery protection.

=end
#########################################

# For info on tables and regionservers
scan 'hbase:meta', { COLUMNS => [ 'info:server', 'info:regioninfo' ] }
# NOTE: .META. no longer exists, hbase:meta used instead

# For info on which servers have parts of meta table
# scan '-ROOT-', { COLUMNS => [ 'info:server', 'info:regioninfo' ] }
# NOTE: -ROOT- has been deprecated


# Create links table, which will be populated from wiki table
create 'links', {NAME => 'to', VERSIONS => 1, BLOOMFILTER => 'ROWCOL'},{NAME => 'from', VERSIONS => 1, BLOOMFILTER => 'ROWCOL'}
# Creating a separate table has the advantage that the tables have separate regions.
# This means that the cluster can more effectively split regions as necessary.

# To see all existing tables:
list

# Populate links table from wiki table
# ${HBASE_HOME}/bin/hbase shell generate_wiki_links.rb


#########################################
###
###        CLOUD  (Thrift)
###
#########################################
=begin

sudo apt-get install automake bison flex g++ git libboost1.55-all-dev libevent-dev libssl-dev libtool make pkg-config thrift-compiler

# Download from http://www.apache.org/dyn/closer.cgi?path=/thrift/0.9.3/thrift-0.9.3.tar.gz
cd ~/Downloads
tar -zxf thrift-0.9.3.tar.gz
cd thrift-0.9.3
./configure && make
cd ..
wget https://raw.githubusercontent.com/eljefe6a/HBaseThrift/master/Hbase.thrift
thrift --gen rb ~/Downloads/Hbase.thrift
${HBASE_HOME}/bin/hbase-daemon.sh start thrift -b 127.0.0.1

# Make thrift_example.rb from book, then run:
cd ${HBASE_HOME}
ruby /path/to/thrift_example.rb

=end

#####################################################
###
###        CLOUD (Basic AWS instead of Whirr, below)
###
#####################################################

=begin 	

# Create AWS account and start an EC2 instance (just use free tier stuff)
# Setup Hbase and Thrift like local (I didn't use "-b 127.0.0.1" when starting thrift)

# Do operations in remote with local scripts by changing localhost to the server name

# This doesn't automate handling the cluster, but AWS Elastic MapReduce (EMR) is 
# supposed to be able to do that, but not part of free tier

# DemoClient.rb modified from apache github:
# https://github.com/apache/hbase/blob/master/hbase-examples/src/main/ruby/DemoClient.rb
	
=end


#########################################
###
###        CLOUD  (Whirr)
###
#########################################
=begin
################################################
### COULDNT GET TO WORK. AWS-EC2 API CHANGE? ###
################################################
	
# Download KEYS, whirr-0.7.1.tar.gz, and whirr-0.7.1.tar.gz.asc from http://archive.apache.org/dist/whirr/
# Use whirr-0.7.1, not 0.8.2
cd Downloads
gpg --import KEYS
gpg --verify whirr-0.7.1.tar.gz.asc whirr-0.7.1.tar.gz

# Create AWS account and access keys for the account
# Use keys in hbase.properties
# Move hbase.properties and keys folder into whirr directory	
=end
