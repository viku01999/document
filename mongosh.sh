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
mongoimport \
  --db oem_service_manager_db \
  --collection filtersByCategory \
  --file /home/ubuntu/Documents/oem_service_manager_db.filtersByCategory.json \
  --jsonArray \
  --username yourMongoUser \
  --password yourMongoPassword \
  --authenticationDatabase admin

# See the details of collections
echo "Showing details of collections..."
db.commonFilters.find().pretty()



# drop contraint in mongo db
use oem_credentials
db.oemcredentials.dropIndex("providerContractId_1")
db.oemcredentials.getIndexes()



//mongo_dump bson
mongodump --host=localhost --port=27017 \
  --username=yourMongoUsername \
  --password=yourMongoPassword \
  --authenticationDatabase=admin \
  --db=oem_credentials \
  --out=/home/ubuntu/Documents

  //json
  mongoexport   --uri="mongodb://username:password@localhost:27017/oem_credentials?authSource=admin"   --collection=oemcredentials   --out=oemcredentials.json   --type=json
mongoexport   --uri="mongodb://username:password@localhost:27017/oem_credentials?authSource=admin"   --collection=oemcredentials   --type=csv   --fields=$FIELDS   --out=oemcredentials.csv


//mongo restore
mongorestore --db=oem_credentials /home/ubuntu/Documents/oem_credentials


mongorestore \
  --host=localhost \
  --port=27017 \
  --username=yourMongoUsername \
  --password=yourMongoPassword \
  --authenticationDatabase=admin \
  --db=oem_credentials \
  /home/ubuntu/Documents/oem_credentials




mongosh -u admin -p mypassword --authenticationDatabase admin
