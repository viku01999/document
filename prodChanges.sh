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





# ** For DGRE TASKING ORDRE **
# To update all the records at once there is two record please check complete json something wrong with this happened
update order_masters
set "provider" = 'iceye', "startTime" = '2025-02-12 00:37:00', "endTime" = '2025-02-15 10:36:00', "task_Id" = '5c1f3b71-e5e9-40f6-b321-ff74505aa6a7', "orderStatus" = 'Completed'
where "orderId" = '91762c5f-6334-48bb-9089-59c3c8352854'

update order_masters
set "reqDataJson" = '{
    "endTime": "2025-02-15T08:45:02.644847Z",
    "provider": "iceye",
    "orderName": "DGRE",
    "orderType": "tasking",
    "startTime": "2025-02-12T14:40:38.621581Z",
    "offerPrice": 0.00,
    "orderItems": [
        {
            "iceye": {
                "price": 0.00,
                "chargeBy": "Scene",
                "taskName": "DGRE",
                "imagingMode": "SPOTLIGHT",
                "windowEndAt": "2025-02-15T08:55:02.644847Z",
                "windowStartAt": "2025-02-12T14:40:38.621581Z",
                "targetedGeom": [34.276833, 75.39089],
                "exclusivity": "PRIVATE",
                "fulfilledAt": "2025-02-15T08:55:02.644847",
                "incidenceAngle": {
                    "max": 40,
                    "min": 20
                },
                "lookSide": "ANY",
                "passDirection": "ANY",
                "priority": "COMMERCIAL",
                "sla": "SLA_7H",
                "status": "DONE",
                "createdAt": "2025-02-12T14:40:38.621581Z",
                "updatedAt": "2025-02-15T09:20:47.71802Z",
                "acquisitionWindow": {
                    "start": "2025-02-12T14:40:38.621581Z",
                    "end": "2025-02-15T08:55:02.644847Z"
                }
            }
        }
    ],
    "repeatCycle": 0,
    "orgProfileId": "1732ffeb-423a-4fb6-9382-ef906b6d253b",
    "orderCategory": "single",
    "totalOrderValue": 0.00
}'
where "orderId" = '91762c5f-6334-48bb-9089-59c3c8352854';

# Update final date json in tasking sub order table
UPDATE order_tasking
SET "finalDataJson" = '[
  {
    "expires_at": "",
    "downloadUrl": "https://spade.suhora.com/public/services/dgre/tasking/ce136883-7d9b-41d3-a8d5-9d976c0785cd/SLH_4484968_316537.zip"
  }
]'
WHERE "taskingSubOrderId" = '8b8a236d-5281-4f7d-a3b4-06bfa972dbe3';






# ** For NIOT TASKING ORDRE **
# To update all the records at once
ref --------------
# first delete previous resqust data json and res data json and then add
DELETE FROM order_tasking
WHERE "orderMasterOrderId" = 'b6ab5268-1799-4231-9a78-3c157e0a1c13';

# New req data json and response data json and other fileds
niot.json

# Delete order tasking similerly delete all the records
DELETE FROM order_tasking
WHERE "taskingSubOrderId" IN ('ff0aec47-aa86-4363-b03c-83ad8e363c36', '1234391f-4027-4334-9dcc-3511a2096abc', '63fc57cb-bbc3-4d7f-a431-aaa657f1fea4');

# Delete all other orders of order master 
DELETE FROM order_masters
WHERE "orderId" IN ('40a9dd08-4993-41c1-8cf3-e483fe2dc1dc', 'ece325af-e48f-4b1d-837d-f12c5b1e046c', '0ff16580-fe67-404f-b4ba-0f8eb5a87362');





# ** Step 9: For NRSC Order **
# Update the status of NRSC order tasking to Completed
update order_archive
set "currentStatus" = 'Completed'
where "orderMasterOrderId" = 'de528178-5935-470e-bcb2-dcbb1436318b';

# Set final data json for all archive order id
UPDATE order_archive
SET "finalDataJson" = '[
  {
    "expires_at": "",
    "downloadUrl": "https://spade.suhora.com/public/services/SAR/Stripmap/NRSC/NRSC_INSAR/PON_000006972_0000587617_1.zip"
  }
]'
WHERE "archiveSubOrderId" = '8eda9b44-2e63-450b-951d-b5fa6dc7ccff';

UPDATE order_archive
SET "finalDataJson" = '[
  {
    "expires_at": "",
    "downloadUrl": "https://spade.suhora.com/public/services/SAR/Stripmap/NRSC/NRSC_INSAR/PON_000006972_0000587619_2.zip"
  }
]'
WHERE "archiveSubOrderId" = '84523f48-7c3a-4da5-a65c-03d0b40f923c';

UPDATE order_archive
SET "finalDataJson" = '[
  {
    "expires_at": "",
    "downloadUrl": "https://spade.suhora.com/public/services/SAR/Stripmap/NRSC/NRSC_INSAR/PON_000006972_0000587620_3.zip"
  }
]'
WHERE "archiveSubOrderId" = '52498620-f7d8-4bdd-9747-21c45ca846c3';

UPDATE order_archive
SET "finalDataJson" = '[
  {
    "expires_at": "",
    "downloadUrl": "https://spade.suhora.com/public/services/SAR/Stripmap/NRSC/NRSC_INSAR/PON_000006972_0000587621_4.zip"
  }
]'
WHERE "archiveSubOrderId" = '9e6415b9-38a0-4124-abe4-f1b47ef087e4';

UPDATE order_archive
SET "finalDataJson" = '[
  {
    "expires_at": "",
    "downloadUrl": "https://spade.suhora.com/public/services/SAR/Stripmap/NRSC/NRSC_INSAR/PON_000006972_0000587623_5.zip"
  }
]'
WHERE "archiveSubOrderId" = '8492ae06-fcb5-4ba7-93eb-a119ed744b30';

UPDATE order_archive
SET "finalDataJson" = '[
  {
    "expires_at": "",
    "downloadUrl": "https://spade.suhora.com/public/services/SAR/Stripmap/NRSC/NRSC_INSAR/PON_000006972_0000587624_6.zip"
  }
]'
WHERE "archiveSubOrderId" = 'd53f1cbe-49b2-4e16-8311-60f0ee587bee';

UPDATE order_archive
SET "finalDataJson" = '[
  {
    "expires_at": "",
    "downloadUrl": "https://spade.suhora.com/public/services/SAR/Stripmap/NRSC/NRSC_INSAR/PON_000006972_0000587634_7.zip"
  }
]'
WHERE "archiveSubOrderId" = 'fc4be608-43b5-4311-877c-a710d068a41a';




select * from organization_contract_binding where contract_id = 'ff992063-c692-47e0-a843-182dd33a761c';
f9afa8f2-df36-47fd-a799-91c249564c86
update organization_contract_binding set valid_till = '2025-07-11' where org_contrcat_binding_id = 'f9afa8f2-df36-47fd-a799-91c249564c86';
