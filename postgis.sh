#!/bin/bash

# This script installs PostgreSQL 16 and PostGIS on an Ubuntu EC2 instance,
# creates a new PostgreSQL database, and enables the PostGIS extension.
# You need to run this script as root or with sudo privileges.

# Step 1: Update System
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install PostgreSQL 16
echo "Installing PostgreSQL 16..."
sudo apt install -y postgresql postgresql-contrib

# Step 3: Install PostGIS for PostgreSQL 16
echo "Installing PostGIS extension for PostgreSQL 16..."
sudo apt install -y postgis postgresql-16-postgis-3

# Step 4: Switch to the PostgreSQL User
echo "Switching to PostgreSQL user..."
sudo -i -u postgres

# Step 5: Create a New PostgreSQL Database (Replace 'my_database' with your preferred name)
echo "Creating a new PostgreSQL database 'my_database'..."
createdb my_database

# Step 6: Enable PostGIS Extension in the Database
echo "Enabling PostGIS extension in 'my_database'..."
psql -d my_database -c "CREATE EXTENSION postgis;"
psql -d my_database -c "CREATE EXTENSION postgis_topology;"  # Optional: For topology support

# Step 7: Verify PostGIS Installation
echo "Verifying PostGIS installation..."
psql -d my_database -c "SELECT PostGIS_Version();"

# Step 8: Final Cleanup and Exit
echo "PostGIS setup completed successfully!"
exit
