# Intro to create, put, get
create 'wiki', 'text'
put 'wiki', 'Home', 'text:', 'Welcome to the wiki!'
get 'wiki', 'Home', 'text:'

# Intro to altering a table
disable 'wiki'
alter 'wiki', { NAME => 'text', VERSIONS => org.apache.hadoop.hbase.HConstants::ALL_VERSIONS }
alter 'wiki', { NAME => 'revision', VERSIONS => org.apache.hadoop.hbase.HConstants::ALL_VERSIONS }
enable 'wiki'


# hbase shell put_multiple_columns.rb


# Check script results
get 'wiki', 'Home'

# To delete a single column value, e.g.: 
# delete 'wiki', 'Home', 'revision:author'
# or
# wiki.delete 'Home', 'revision:author'
#
# More generally:
# delete 'table', 'row', 'columnFamily:column'


# To delete a row, e.g.:
# deleteall 'wiki', 'Home'