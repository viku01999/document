#!/bin/bash

# Set PATH explicitly for cron environment
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Define variables for PostgreSQL user, database names, and backup directories
PGUSER=""        # Replace with your PostgreSQL user
PGHOST=""       # Adjust if your PostgreSQL is on a remote server
PGPORT=""               # Adjust if your PostgreSQL is using a different port
PGPASSWORD=""  # Replace with your PostgreSQL password
BACKUP_BASE_DIR="$HOME/Documents/db_backup"  # Base directory for backups

# Email recipients
EMAIL_TO=""  # Primary recipient
EMAIL_CC=""  # CC recipient (can be empty or multiple emails)
EMAIL_BCC=""  # BCC recipient (optional)

# SMTP server configuration - fill in your credentials here
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT=587
SMTP_USERNAME=""
SMTP_PASSWORD=""

# Databases to backup
DB_NAMES=("db1" "db2" "db3")

# Array to hold backup file paths for email attachment
BACKUP_FILES=()

# Loop through each database and perform the backup
for DB in "${DB_NAMES[@]}"
do
  BACKUP_DIR="$BACKUP_BASE_DIR/$DB"
  DATE=$(date +%Y%m%d%H%M)
  echo "DEBUG: DATE variable is '$DATE'"
  BACKUP_FILE="$BACKUP_DIR/${DB}_$DATE.sql"
  echo "DEBUG: Backup file path is '$BACKUP_FILE'"

  # Create backup directory if it doesn't exist
  mkdir -p "$BACKUP_DIR"

  # Set PGPASSWORD environment variable to avoid password prompt
  export PGPASSWORD=$PGPASSWORD

  # Create backup using pg_dump
  if pg_dump -U $PGUSER -h $PGHOST -p $PGPORT $DB > $BACKUP_FILE; then
    echo "Backup of $DB completed: $BACKUP_FILE"
    BACKUP_FILES+=("$BACKUP_FILE")
  else
    echo "Backup of $DB failed!"
    exit 1
  fi
done

# Delete backup files older than 30 days
find $BACKUP_BASE_DIR -type f -name "*.sql" -mtime +30 -exec rm {} \;
echo "Old backup files (older than 30 days) deleted."

# Check if swaks is installed for SMTP email sending, install if missing (Debian/Ubuntu)
if ! command -v swaks &> /dev/null
then
    echo "swaks not found. Installing swaks..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get update && sudo apt-get install -y swaks
    else
        echo "Unsupported OS for automatic swaks installation. Please install swaks manually."
        exit 1
    fi
else
    echo "swaks is already installed."
fi

# Find the three most recent backup files across all databases for email attachment
RECENT_BACKUPS=$(find "$BACKUP_BASE_DIR" -type f -name "*.sql" -printf '%T@ %p\n' | sort -nr | head -n 3 | cut -d' ' -f2-)

# Prepare email subject and body
EMAIL_SUBJECT="PostgreSQL Backup Successful - $(date +'%Y-%m-%d %H:%M')"
EMAIL_BODY="The PostgreSQL backup completed successfully. Attached are the three most recent backup files."

# Prepare attachments parameters for swaks
ATTACHMENTS=""
for file in $RECENT_BACKUPS; do
  ATTACHMENTS+="--attach @$file "
done

# Build swaks command with CC and BCC support
SWAKS_CMD="swaks --to \"$EMAIL_TO\" --from \"$SMTP_USERNAME\" --server \"$SMTP_SERVER\" --port $SMTP_PORT --auth LOGIN --auth-user \"$SMTP_USERNAME\" --auth-password \"$SMTP_PASSWORD\" --tls --header \"Subject: $EMAIL_SUBJECT\" --body \"$EMAIL_BODY\" $ATTACHMENTS"

# Add CC if provided
if [ -n "$EMAIL_CC" ]; then
    SWAKS_CMD="$SWAKS_CMD --cc \"$EMAIL_CC\""
fi

# Add BCC if provided
if [ -n "$EMAIL_BCC" ]; then
    SWAKS_CMD="$SWAKS_CMD --bcc \"$EMAIL_BCC\""
fi

# Execute the swaks command
eval $SWAKS_CMD

if [ $? -eq 0 ]; then
  echo "Backup success email sent to $EMAIL_TO and $EMAIL_CC and $EMAIL_BCC successfully."
else
  echo "Failed to send backup success email"
  exit 1
fi




# manual check
# /bin/bash ~/Documents/pg_backup.sh
# run in terminal using bash bash ~/Documents/pg_backup_mail.sh

