$:.push('~/Downloads/thrift-0.9.3/lib/rb/lib')
$:.push('/opt/hbase-1.1.3/gen-rb')
require 'thrift'
require 'hbase'

socket = Thrift::Socket.new( 'localhost', 9090 )#'ec2-54-215-238-60.us-west-1.compute.amazonaws.com', 9090 )
transport = Thrift::BufferedTransport.new( socket )
protocol = Thrift::BinaryProtocol.new( transport )
client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new( protocol )

transport.open()

t = "New table"
columns = []
col = Apache::Hadoop::Hbase::Thrift::ColumnDescriptor.new
col.name = "firstColumn:"
col.maxVersions = 10
columns << col;
col = Apache::Hadoop::Hbase::Thrift::ColumnDescriptor.new
col.name = "secondColumn:"
columns << col;

client.createTable(t, columns)
puts "#{t} created"

transport.close()