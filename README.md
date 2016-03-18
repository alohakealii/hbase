#Setup

## Installation
Download the software from https://hbase.apache.org/

Specifically, I downloaded **hbase-1.1.3-bin.tar.gz** from http://www-us.apache.org/dist/hbase/stable/, and verified the file per their instructions at https://www.apache.org/dyn/closer.cgi#verify.

I moved the extracted folder (hbase-1.1.3) to `/opt/` and created the script, *hbase*, to put into `/usr/local/bin`, which allows you to enter `hbase` instead of `${HBASE_HOME}/bin/hbase` as the book uses.

### To simplify entering commands, I added the following to .bashrc:
```bash
export HBASE_HOME=/opt/hbase-1.1.3
export PATH=$PATH:$HBASE_HOME
alias start-hbase=$HBASE_HOME/bin/start-hbase.sh
alias stop-hbase=$HBASE_HOME/bin/stop-hbase.sh
log-hbase() {
	find ${HBASE_HOME}/logs -name "hbase-*.log" -exec tail -f {} \;
}
```

## Troubleshooting
If you can't figure out what's wrong, look at the logs. If it looks a bit overwhelming, try searching for the errors. For example, when in ${HBASE_HOME}/logs,  `grep "Exception" hbase-<username>-master-<hostname>.out` gave me:
```
java.net.UnknownHostException: lo: Name or service not known
java.net.UnknownHostException: lo
2016-03-18 09:05:24,852 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo
2016-03-18 09:05:25,853 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo
2016-03-18 09:05:27,855 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo
2016-03-18 09:05:31,857 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo: Name or service not known
2016-03-18 09:05:40,006 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
2016-03-18 09:05:40,007 ERROR [main] zookeeper.ZooKeeperWatcher: hconnection-0x6435d8240x0, quorum=lo:2181, baseZNode=/hbase Received unexpected KeeperException, re-throwing exception
org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo
2016-03-18 09:05:40,065 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo
2016-03-18 09:05:41,067 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo
2016-03-18 09:05:43,070 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo
2016-03-18 09:05:47,072 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
java.net.UnknownHostException: lo: Name or service not known
2016-03-18 09:05:55,224 WARN  [main] zookeeper.RecoverableZooKeeper: Possibly transient ZooKeeper, quorum=lo:2181, exception=org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
2016-03-18 09:05:55,225 ERROR [main] zookeeper.ZooKeeperWatcher: hconnection-0x6435d8240x0, quorum=lo:2181, baseZNode=/hbase Received unexpected KeeperException, re-throwing exception
org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
org.apache.hadoop.hbase.client.RetriesExhaustedException: Failed after attempts=1, exceptions:
Fri Mar 18 09:05:55 PDT 2016, RpcRetryingCaller{globalStartTime=1458317140062, pause=100, retries=1}, org.apache.hadoop.hbase.MasterNotRunningException: org.apache.hadoop.hbase.MasterNotRunningException: Can't get connection to ZooKeeper: KeeperErrorCode = OperationTimeout
Caused by: org.apache.hadoop.hbase.MasterNotRunningException: org.apache.hadoop.hbase.MasterNotRunningException: Can't get connection to ZooKeeper: KeeperErrorCode = OperationTimeout
Caused by: org.apache.hadoop.hbase.MasterNotRunningException: Can't get connection to ZooKeeper: KeeperErrorCode = OperationTimeout
Caused by: org.apache.zookeeper.KeeperException$OperationTimeoutException: KeeperErrorCode = OperationTimeout
```

I fixed it by adding "127.0.0.1    lo" to /etc/hosts