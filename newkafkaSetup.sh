#!/bin/bash

# ============================================================================
# Kafka 4.0.0 Setup Script (KRaft Mode - No ZooKeeper)
# ============================================================================
# This script includes full documentation, setup instructions, and a working
# configuration for running Apache Kafka 4.0.0 in KRaft mode.
# It explains control flow, UUID usage, restart instructions, and includes
# producer/consumer command examples.
# ============================================================================

# ---------------------------------------------
# 📌 Kafka Without ZooKeeper: The Transition to KRaft
# ---------------------------------------------
# In this script and documentation:
# - Overview of ZooKeeper removal
# - KRaft architecture
# - Comparison with old system
# - Step-by-step setup
# - Explanation of how Kafka works internally
# - Restart instructions, UUID role
# - Producer/Consumer usage

# ----------------------------------------------------------------------------
# 🛠 Why Did Kafka Remove ZooKeeper?
# ----------------------------------------------------------------------------
# - ZooKeeper was a separate coordination system used for metadata & leader election.
# - Problems with ZooKeeper:
#   1. External dependency
#   2. Slow leader elections
#   3. Poor scalability with large clusters
#   4. Operational overhead
#
# KRaft (Kafka Raft) replaces ZooKeeper with an internal Raft-based consensus protocol.
# Benefits of KRaft:
# ✅ Simpler deployment
# ✅ Faster leader election (milliseconds)
# ✅ Higher scalability
# ✅ Lower maintenance

# ----------------------------------------------------------------------------
# 🏗 Kafka’s Old vs. New Architecture
# ----------------------------------------------------------------------------
# OLD (ZooKeeper):
# - Metadata stored externally
# - Slower failover, more latency
#
# NEW (KRaft):
# - Kafka brokers manage metadata internally
# - Uses Raft log for consensus
# - Brokers are both data handlers and metadata controllers

# ----------------------------------------------------------------------------
# ⚖️ ZooKeeper vs KRaft Comparison
# ----------------------------------------------------------------------------
# | Feature               | ZooKeeper        | KRaft            |
# |----------------------|------------------|------------------|
# | Metadata Management  | External (ZK)     | Internal (Kafka) |
# | Leader Election      | Seconds           | Milliseconds     |
# | Scalability          | Limited           | High             |
# | Setup Complexity     | High              | Low              |
# | Failure Recovery     | Slower            | Faster           |

# ----------------------------------------------------------------------------
# ✅ STEP 1: Download & Build Kafka 4.0.0
# ----------------------------------------------------------------------------
wget https://downloads.apache.org/kafka/4.0.0/kafka-4.0.0-src.tgz

tar -xvzf kafka-4.0.0-src.tgz
cd kafka-4.0.0-src
./gradlew clean releaseTarGz

# Extract the binary package
cd core/build/distributions

mkdir -p ~/kafka && tar -xvzf kafka_*.tgz -C ~/kafka --strip-components=1
cd ~/kafka

# ----------------------------------------------------------------------------
# ✅ STEP 2: Configure Environment Variables
# ----------------------------------------------------------------------------
echo "export KAFKA_HOME=\"$HOME/kafka\"" >>~/.bashrc
echo "export PATH=\$PATH:\$KAFKA_HOME/bin" >>~/.bashrc
source ~/.bashrc
#export KAFKA_HOME=/usr/local/kafka_2.13-4.0.0
#export PATH=$PATH:$KAFKA_HOME/bin

# ----------------------------------------------------------------------------
# ✅ STEP 3: Configure server.properties for KRaft Mode
# ----------------------------------------------------------------------------
mkdir -p ~/kafka/config
cat <<EOF >~/kafka/config/server.properties

process.roles=broker,controller
node.id=1
controller.quorum.voters=1@192.168.29.13:9093

listeners=PLAINTEXT://192.168.29.13:9092,CONTROLLER://192.168.29.13:9093
advertised.listeners=PLAINTEXT://192.168.29.13:9092
inter.broker.listener.name=PLAINTEXT
controller.listener.names=CONTROLLER
listener.security.protocol.map=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT

log.dirs=/tmp/kraft-combined-logs
metadata.log.dir=/tmp/kraft-metadata
num.partitions=1
num.recovery.threads.per.data.dir=1

log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000

offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

min.insync.replicas=1
EOF

# ----------------------------------------------------------------------------
# ✅ STEP 4: Generate Cluster UUID & Format Storage
# ----------------------------------------------------------------------------
echo "Generating Cluster UUID..."
bin/kafka-storage.sh random-uuid
# ⚠️ Copy the UUID output manually!
# Then run the format command manually replacing <uuid> with your UUID:
bin/kafka-storage.sh format -t <uuid> -c config/server.properties
# Automatically you have to do this if you dont want to generate and setup manually
CLUSTER_ID=$(bin/kafka-storage.sh random-uuid)
echo "Generated Cluster ID: $CLUSTER_ID"
bin/kafka-storage.sh format -t $CLUSTER_ID -c config/server.properties


# ----------------------------------------------------------------------------
# ✅ STEP 5: Start Kafka Server (NO ZooKeeper Needed)
# ----------------------------------------------------------------------------
# Start Kafka:
# bin/kafka-server-start.sh config/server.properties

# ----------------------------------------------------------------------------
# 🔁 AFTER REBOOT / SYSTEM RESTART
# ----------------------------------------------------------------------------
# ✅ You do NOT need to generate UUID again.
# ✅ You do NOT need to format again.
# ✅ Just run:
# cd ~/kafka
# bin/kafka-server-start.sh config/server.properties

# ----------------------------------------------------------------------------
# 📚 How Kafka Works (Control Flow Overview)
# ----------------------------------------------------------------------------
# - Kafka Broker now also acts as the metadata controller.
# - Uses Raft consensus to elect a controller among quorum voters.
# - Topics are created and stored in replicated logs.
# - Metadata is persisted internally, removing need for ZooKeeper.
# - Fast failover: if controller fails, another broker takes over quickly.

# ----------------------------------------------------------------------------
# ✅ Producer Example
# ----------------------------------------------------------------------------
# Create topic:
bin/kafka-topics.sh --create --topic demo-topic --bootstrap-server 192.168.29.13:9092 --partitions 1 --replication-factor 1

# Produce messages:
echo "Welcome to Kafka KRaft mode!" | bin/kafka-console-producer.sh --broker-list 192.168.29.13:9092 --topic demo-topic

# ----------------------------------------------------------------------------
# ✅ Consumer Example
# ----------------------------------------------------------------------------
# Consume messages:
bin/kafka-console-consumer.sh --bootstrap-server 192.168.29.13:9092 --topic demo-topic --from-beginning

# ----------------------------------------------------------------------------
# ✅ List Topics, Describe Topics
# ----------------------------------------------------------------------------
bin/kafka-topics.sh --list --bootstrap-server 192.168.29.13:9092
bin/kafka-topics.sh --describe --topic demo-topic --bootstrap-server 192.168.29.13:9092

# ----------------------------------------------------------------------------
# 🎯 Conclusion: Why Move to KRaft?
# ----------------------------------------------------------------------------
# - No ZooKeeper required
# - Easier configuration
# - Better performance and failover
# - Supports very large clusters (10,000+ brokers)
# - Production-ready consensus built into Kafka

# ----------------------------------------------------------------------------
# 🎥 YouTube Video Structure (Optional)
# ----------------------------------------------------------------------------
# 1. [Intro] - Why Kafka removed ZooKeeper?
# 2. [Old vs. New Architecture]
# 3. [Why KRaft is Better]
# 4. [Setup & Migration Guide]
# 5. [Performance Comparison]
# 6. [Conclusion]


# Cleanup and restart
# To completely delete all Kafka data
rm -rf /tmp/kraft-combined-logs /tmp/kraft-metadata

#Delete Old Kafka Data and Metadata(log directory info is sudo nano config/server.properties)(optionally)
rm -rf /tmp/kraft-combined-logs


#After this cleanup, follow these steps to reinitialize:
bin/kafka-storage.sh random-uuid
bin/kafka-storage.sh format -t zZVgy9GOTlOzW7R0iKSYfg -c config/server.properties
bin/kafka-server-start.sh config/server.properties


# END OF SCRIPT














#-----------------------------------------------bin/properties------------------
#!/bin/bash

# limitations under the License.

if [ $# -lt 1 ]; then
    echo "USAGE: $0 [-daemon] server.properties [--override property=value]*"
    exit 1
fi

base_dir=$(dirname $0)

# Set Kafka log4j options if not already set
if [ -z "$KAFKA_LOG4J_OPTS" ]; then
    export KAFKA_LOG4J_OPTS="-Dlog4j2.configurationFile=$base_dir/../config/log4j2.yaml"
fi

# Set default Kafka heap memory settings
if [ -z "$KAFKA_HEAP_OPTS" ]; then
    export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
fi

# Clean Kafka start: remove JMX exporter
# export KAFKA_OPTS is intentionally omitted

EXTRA_ARGS=${EXTRA_ARGS-'-name kafkaServer -loggc'}

COMMAND=$1
case $COMMAND in
  -daemon)
    EXTRA_ARGS="-daemon $EXTRA_ARGS"
    shift
    ;;
  *)
    ;;
esac

# Run Kafka
exec $base_dir/kafka-run-class.sh $EXTRA_ARGS kafka.Kafka "$@"







# ---------------------------------------- setup in file in  kafka server-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
############################# Server Basics #############################

# Enable KRaft mode
process.roles=broker,controller

# Unique ID for this Kafka node
node.id=1

# Define the controller quorum (this is the controller address)
controller.quorum.voters=1@192.168.29.13:9093

############################# Socket Server Settings #############################

# Define the listeners for Kafka broker and controller
listeners = PLAINTEXT://192.168.29.13:9092,CONTROLLER://192.168.29.13:9093

# Define inter-broker communication protocol
inter.broker.listener.name=PLAINTEXT

# Define advertised listeners (used by clients)
advertised.listeners=PLAINTEXT://192.168.29.13:9092

# Define which listener the controller will use
controller.listener.names=CONTROLLER

# Map listener names to security protocols
listener.security.protocol.map=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT

############################# Log Storage #############################

# Directory to store Kafka logs
log.dirs=/tmp/kraft-combined-logs

# Default number of partitions per topic
num.partitions=1

# Number of threads per log directory for log recovery
num.recovery.threads.per.data.dir=1

############################# Internal Topics #############################

# Replication factor for internal topics (should be >1 in production)
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

############################# Log Retention Policy #############################

# Retain logs for 7 days
log.retention.hours=168

# Maximum size of a log segment
log.segment.bytes=1073741824

# Interval for checking log retention policies
log.retention.check.interval.ms=300000





# Run this following command after adding this file into server.properties
# run this following command
bin/kafka-storage.sh random-uuid

bin/kafka-storage.sh format -t here config/server.properties <uuid >-c

# To run the kafka
bin/kafka-server-start.sh config/server.properties









