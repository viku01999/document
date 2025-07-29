#!/for production 1.3 deployment before deploy

# ** Step 1: ssh **
# SSH into the server where the application will be deployed
ssh -i /path/to/your/private/key user@your_server_ip
ssh -i ~/Downloads/Backend_Suhora.pem ubuntu@13.127.184.71


# ** Step 2: Update the server **
# Update the server's software
sudo apt-get update

sudo apt-get upgrade -y
  
# ** Step 3: Access postgresql **
# Connect to the PostgreSQL database server
echo "Connecting to PostgreSQL database..."
sudo -i -u postgres

echo "Opens the PostgreSQL interactive terminal ..."
psql

# ** Step 4: List out all the databases **
# To get all the databases
echo "Listing all databases..."
\l

# ** Step 5: Drop the database **
# To switch to the database
echo "Switching to the database..."
\c your_database_name

# ** Step 6: List tables to all databases **
# To list all tables in the current database
echo "Listing tables in the current database..."
\dt

# ** Step 7: Drop the table **
# To drop a table
echo "Dropping the table..."
DROP TABLE your_table_name

# ** Step 8: Updated data of perticuler row **
# To update a specific row in a table
echo "Updating data in the table..."
UPDATE your_table_name
SET your_column_name = 'your_new_value'
WHERE your_condition



