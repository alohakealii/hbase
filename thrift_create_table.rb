$:.push('./gen-rb')
require 'thrift'
require 'hbase'

socket = Thrift::Socket.new( 'ec2-54-215-238-60.us-west-1.compute.amazonaws.com', 9090 )
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

if client.createTable(t, columns)
	puts "#{t} created"
else
	puts "something happen?"
end

transport.close()