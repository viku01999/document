#!/bin/bash

# PostgreSQL Automated Backup Setup Guide

# Step 1: Create the Backup Directory Structure

cd ~/Documents

# Create main backup directory
mkdir db_backup

# Create subdirectories for each database
mkdir db_backup/spade_order
mkdir db_backup/external_user
mkdir db_backup/internal_user

# Directory Structure:
# ~/Documents/db_backup/
# │
# ├── spade_order/
# ├── external_user/
# └── internal_user/

# Step 2: Create the Backup Script

# Create and edit the pg_backup.sh script
nano ~/Documents/pg_backup.sh

# Add the following script content:

#!/bin/bash

# Define variables for PostgreSQL user, database names, and backup directories
PGUSER="spade_admin"        # Replace with your PostgreSQL user
PGHOST="192.168.29.154"     # Adjust if your PostgreSQL is on a remote server
PGPORT="5432"               # Adjust if your PostgreSQL is using a different port
PGPASSWORD="your_password"  # Replace with your PostgreSQL password
BACKUP_BASE_DIR="$HOME/Documents/db_backup"  # Base directory for backups

# Databases to backup
DB_NAMES=("spade_order" "external_user" "internal_user")

# Loop through each database and perform the backup
for DB in "${DB_NAMES[@]}"
do
  BACKUP_DIR="$BACKUP_BASE_DIR/$DB"
  DATE=$(date +\%Y\%m\%d\%H\%M)
  BACKUP_FILE="$BACKUP_DIR/$DB-$DATE.sql"

  # Set PGPASSWORD environment variable to avoid password prompt
  export PGPASSWORD=$PGPASSWORD

  # Create backup using pg_dump
  pg_dump -U $PGUSER -h $PGHOST -p $PGPORT $DB > $BACKUP_FILE

  echo "Backup of $DB completed: $BACKUP_FILE"
done

# Delete backup files older than 30 days
find $BACKUP_BASE_DIR -type f -name "*.sql" -mtime +30 -exec rm {} \;
echo "Old backup files (older than 30 days) deleted."

# Step 3: Make the Script Executable
chmod +x ~/Documents/pg_backup.sh

# Step 4: Schedule the Backup using Cron

# Edit crontab to schedule the backup at midnight every day
crontab -e

# Add the following line to run the backup script at midnight (00:00 every day):
# 0 0 * * * /bin/bash /home/your_username/Documents/pg_backup.sh

# Step 5: Verify the Script Works

# Manually run the script to verify everything is working:
# /bin/bash ~/Documents/pg_backup.sh

# Folder and File Structure:
# After the backups are created, the folder structure will be as follows:
# ~/Documents/db_backup/
# │
# ├── spade_order/
# │   ├── spade_order-20250221XXXX.sql
# │   ├── spade_order-20250222XXXX.sql
# │   └── ...
# ├── external_user/
# │   ├── external_user-20250221XXXX.sql
# │   ├── external_user-20250222XXXX.sql
# │   └── ...
# └── internal_user/
#     ├── internal_user-20250221XXXX.sql
#     ├── internal_user-20250222XXXX.sql
#     └── ...

# Step 6: Monitor and Troubleshoot

# You can monitor the cron jobs and troubleshoot any issues using the following command:
# grep CRON /var/log/syslog
