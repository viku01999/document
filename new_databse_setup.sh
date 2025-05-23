#!/bin/bash

# Step 1: Log in as the 'postgres' user and run psql commands

echo "Starting PostgreSQL setup..."

# Use sudo to run the following commands as the 'postgres' user
sudo -i -u postgres
psql


-- Step 2: Change the password for the 'postgres' superuser
echo "Changing password for 'postgres' user..."
ALTER USER postgres WITH PASSWORD 'newpassword';

-- Step 3: Create the user 'spade_admin' with password 'Spade_Suhora@123'
echo "Creating user 'spade_admin'..."
CREATE USER spade_admin WITH PASSWORD 'WZf5RrrQ48egpjio';

-- Step 4: Grant privileges to the user 'spade_admin'
echo "Granting privileges to 'spade_admin'..."
ALTER USER spade_admin WITH 
    LOGIN 
    CREATEDB 
    CREATEROLE 
    REPLICATION 
    INHERIT 
    BYPASSRLS;

-- Step 5: Create databases 'spade_order', 'external_user', and 'internal_user'
echo "Creating databases 'spade_order', 'external_user', and 'internal_user'..."
CREATE DATABASE spade_order;
CREATE DATABASE external_user;
CREATE DATABASE internal_user;

-- Step 6: Change ownership of the databases to 'spade_admin'
echo "Changing ownership of the databases to 'spade_admin'..."
ALTER DATABASE spade_order OWNER TO spade_admin;
ALTER DATABASE external_user OWNER TO spade_admin;
ALTER DATABASE internal_user OWNER TO spade_admin;

-- Step 7: Grant all privileges on the databases to 'spade_admin'
echo "Granting all privileges on databases to 'spade_admin'..."
GRANT ALL PRIVILEGES ON DATABASE spade_order TO spade_admin;
GRANT ALL PRIVILEGES ON DATABASE external_user TO spade_admin;
GRANT ALL PRIVILEGES ON DATABASE internal_user TO spade_admin;

-- Step 8: Grant privileges on all tables, sequences, and functions in the 'public' schema of each database

-- For 'spade_order' database
echo "Granting all privileges on all tables, sequences, and functions in 'spade_order'..."
\c spade_order
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO spade_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO spade_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO spade_admin;

-- For 'external_user' database
echo "Granting all privileges on all tables, sequences, and functions in 'external_user'..."
\c external_user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO spade_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO spade_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO spade_admin;

-- For 'internal_user' database
echo "Granting all privileges on all tables, sequences, and functions in 'internal_user'..."
\c internal_user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO spade_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO spade_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO spade_admin;

-- Step 9: Exit the PostgreSQL session
echo "Exiting PostgreSQL session..."
\q

EOF

echo "Database setup complete! 'spade_admin' has been created, granted the required privileges, and made the owner of all the databases."