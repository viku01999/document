#!/bin/bash

# Before starting the server, create directories
echo "Creating necessary directories..."
mkdir -p ~/Documents/spade_files/images/iceye_downloads
mkdir -p ~/Documents/spade_files/images/profilePics
mkdir -p ~/Documents/spade_files/images/rechargeTransPics
mkdir -p ~/Documents/spade_files/images/subsTransPics
mkdir -p ~/Documents/spade_files/images/ticketPics
echo "Directories created."

# Set Correct Permissions for Directories:
sudo chown -R suhora:suhora /home/suhora/Documents/spade_files/
sudo chmod -R 775 /home/suhora/Documents/spade_files/

# Add Your User to the docker Group
echo "Adding Your User to the docker Group..."
sudo usermod -aG docker suhora

# Log Out and Log Back In: 
echo "Log Out and Log Back In: suhora"
newgrp docker

# Verify Docker Access:
echo "Verify Docker Access: docker ps"
docker ps
docker-compose --version

# SSH into EC2 instance
echo "Connecting to EC2 instance..."
sudo ssh -i /home/suhora/Downloads/Staging_Suhora.pem ubuntu@43.204.153.130

# Edit MongoDB configuration file
echo "Editing MongoDB config..."
sudo nano /etc/mongod.conf

# Edit PostgreSQL configuration file
echo "Editing PostgreSQL config..."
sudo nano /etc/postgresql/16/main/postgresql.conf

# Access PostgreSQL as user 'postgres'
echo "Accessing PostgreSQL as user 'postgres'..."
sudo -i -u postgres
psql -c "\du" # See the roles and permissions

# Grant permissions to the 'spade_admin' role
echo "Granting permissions to spade_admin..."
psql -c "GRANT CREATE, CONNECT, TEMPORARY ON DATABASE your_database TO spade_admin;"
psql -c "GRANT ALL PRIVILEGES ON DATABASE your_database TO spade_admin;"
psql -c "GRANT USAGE, CREATE ON SCHEMA public TO spade_admin;"
psql -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO spade_admin;"
psql -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO spade_admin;"
psql -c "GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO spade_admin;"

# Allow spade_admin to manage roles
echo "Allowing spade_admin to manage roles..."
psql -c "ALTER ROLE spade_admin WITH CREATEROLE;"

# Transfer files from local system to EC2 instance
echo "Transferring files to EC2 instance..."
sudo scp -i ~/Downloads/Staging_Suhora.pem /home/suhora/Downloads/External-User-dashboard.zip ubuntu@43.204.153.130:/home/ubuntu/Documents

# If you want to transfer the entire Exte directory from the EC2 instance to your local
sudo scp -i ~/Downloads/staging_Suhora.pem -r ubuntu@43.204.153.130:/home/ubuntu/Documents/Exte ~/Documents/

# If you're transferring a specific file
sudo scp -i ~/Downloads/staging_Suhora.pem ubuntu@43.204.153.130:/home/ubuntu/Documents/example.txt ~/Documents/

# Transfer file from ec2 instance to my local system
echo "Transferring files from EC2 instance to local system..."
sudo scp -i ~/Downloads/staging_Suhora.pem ubuntu@43.204.153.130:/home/ubuntu/Documents/Exte


# Connect with DB
echo "Connecting to PostgreSQL database..."
sudo -i -u postgres
psql

# Create a new database
echo "Creating new database spade_order..."
psql -c "CREATE DATABASE spade_order;"

# Alter database ownership
echo "Altering database ownership..."
psql -c "ALTER DATABASE your_database_name OWNER TO spade_admin;"
 
# Backup and Restore PostgreSQL database
echo "Backing up PostgreSQL database..."
pg_dump -U username -h localhost databasename >>sqlfile.sql

echo "Restoring PostgreSQL database..."
psql -h hostname -p port_number -U username -f your_file.sql databasename

# List all PostgreSQL databases
echo "Listing all databases..."
psql -c "\l"

# Switch to a specific database
echo "Switching to spade_order database..."
psql -c "\c spade_order"

# List tables in the database
echo "Listing all tables in spade_order..."
psql -c "\dt"

# Java setup
echo "Installing Java..."
sudo apt update
sudo apt install wget -y
wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/23.0.0+0/jdk-23_linux-x64_bin.tar.gz
tar -xvzf jdk-23_linux-x64_bin.tar.gz
sudo mv jdk-23 /opt/

# Update profile with Java environment variables
echo "Setting up Java environment..."
sudo nano /etc/profile
echo "export JAVA_HOME=/opt/jdk-23" >>/etc/profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >>/etc/profile
source /etc/profile

# Verify Java installation
java -version

# Kafka setup
echo "Installing Kafka..."
wget https://dlcdn.apache.org/kafka/3.9.0/kafka_2.12-3.9.0.tgz
sudo tar -xvzf kafka_2.12-3.9.0.tgz
sudo mv kafka_2.12-3.9.0 /usr/local/

cd /usr/local/kafka_2.12-3.9.0/

# Install pnpm
echo "Installing pnpm..."
npm install -g pnpm

# Install tmux
echo "Installing tmux..."
sudo apt update
sudo apt install tmux -y

# tmux commands reference
echo "tmux commands reference..."
echo "Start a new session: tmux"
echo "Attach to a session: tmux attach-session -t 0"
echo "Create a new window: Ctrl + b, then c"
echo "Switch to the next window: Ctrl + b, then n"
echo "Switch to the previous window: Ctrl + b, then p"
echo "Split the window vertically: Ctrl + b, then %"
echo "Split the window horizontally: Ctrl + b, then \""
echo "Switch between panes: Ctrl + b, then arrow keys"
echo "Detach from tmux: Ctrl + b, then d"
echo "Close a window/pane: exit"
echo "List all windows: Ctrl + b, then w"
echo "Rename a window: Ctrl + b, then ,"
echo "List tmux sessions: tmux ls"
echo "Attach tmux session: tmux attach-session -t <session_name>"
# Enable Mouse Mode in the Global Configuration
set -g mouse on
tmux source-file /etc/tmux.conf


# Transfer files and hidden files
echo "Transferring files and hidden files..."
sudo scp -i ~/Downloads/Staging_Suhora.pem /home/suhora/Downloads/external_user.sql ubuntu@43.204.153.130:/home/ubuntu/Documents

# Provide permissions to a directory
echo "Providing permissions to directories..."
sudo chown -R ubuntu:ubuntu /home/ubuntu/Documents/spade_backend/iceye-microservice
sudo chmod -R 777 /home/ubuntu/Documents/spade_backend/iceye-microservice
ls -la /home/ubuntu/Documents/spade_backend/iceye-microservice

# Make unautorise mongo db config
echo "Making unautorise mongo db config..."
sudo nano /etc/mongod.conf

# Open mongosh terminal
echo "Opening mongosh terminal..."
mongosh

# Show all dbs
echo "Showing all dbs..."
show dbs

# Switch into admin
echo "Switching into admin db..."
use admin

# Enter OEM service manager db
echo "Entering OEM service manager db..."
use oem_service_manager

# List out all the collections
echo "Listing out all the collections..."
show collections

# Drop collection
echo "Dropping collection..."
db.commonFilters.drop()

# check head 
head /home/ubuntu/oem_service_manager_db.commonFilters.json

# Import MongoDB data
# First go to the normal terminal
echo "Importing MongoDB data..."
mongoimport --db oem_service_manager_db --collection commonFilters --file /home/ubuntu/Documents/oem_service_manager_db.commonFilters.json --jsonArray

# See the details of collections
echo "Showing details of collections..."
db.commonFilters.find().pretty()

# Install serve to run frontend
echo "Installing serve to run frontend..."
npm install -g serve

# Run frontend using serve
echo "Running frontend using serve..."
serve -s dist -l 5173

# Provide access to spade_files directory
echo "Providing access to spade_files directory..."
sudo chmod -R 777 spade_files

# Setup tmux to run on boot
echo "Setting up tmux to run on boot..."
nano ~/start_tmux_on_boot.sh

echo "#!/bin/bash" >>~/start_tmux_on_boot.sh
echo "# Check if there is an internet connection by pinging a reliable server" >>~/start_tmux_on_boot.sh

# Make the script executable
echo "Making the script executable..."
sudo chown suhora:suhora /home/suhora/start_tmux_on_boot.sh
chmod +x /home/suhora/start_tmux_on_boot.sh
ls -l /home/suhora/start_tmux_on_boot.sh

# Add cron job to run on reboot
echo "Setting up cron job to run tmux script on reboot..."
crontab -e
echo "@reboot /home/suhora/start_tmux_on_boot.sh" >>/etc/crontab

# Set permission to run without password
echo "Setting sudo permissions without password..."
sudo visudo
echo "suhora ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
sudo systemctl restart cron
sudo systemctl start cron
sudo systemctl status cron

# Local check
echo "Running the script locally..."
/home/suhora/start_tmux_on_boot.sh




# --------------------------------------------------------------------------------------------------------------------------

# Drop table
psql -h 127.0.0.1 -U spade_admin -d external_user -c "DROP TABLE IF EXISTS public.oem_master CASCADE;"

# backup in table staging
PGPASSWORD="WZf5RrrQ48egpjio" psql -h 127.0.0.1 -U spade_admin -d external_user -f /home/ubuntu/Documents/oem_backup.sql
pg_dump -h 172.31.31.226 -U spade_admin -W -d external_user -t public.product_master -f product_master.sql

# restore in table staging
PGPASSWORD="WZf5RrrQ48egpjio" psql -h 127.0.0.1 -U spade_admin -d external_user -f /home/ubuntu/Documents/product_master.sql


# ------------------------- drop all table----------------------------------------
DROP TABLE IF EXISTS 
  "SuperAdminPermission",
  "department",
  "internal_user",
  "migrations",
  "permissions",
  "role",
  "role_permissions",
  "super_admin",
  "verification"
CASCADE;




# drop contraint in mongo db
use oem_credentials
db.oemcredentials.dropIndex("providerContractId_1")
db.oemcredentials.getIndexes()