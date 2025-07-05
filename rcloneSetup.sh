#s3 config setup
suhora@stpl-1017:~$ cat /tmp/s3-rcloneconfig.conf 
[s3bucket]
type = s3
provider = AWS
env_auth = false
access_key_id = 
secret_access_key =
region = ap-south-1
acl = private
no_check_bucket = true




# sftp config setup
suhora@stpl-1017:~$ cat /tmp/sftp-rcloneconfig.conf
[sftpserver]
type = sftp
host = 
user = 
pass = 
port = 22


# copy url to sftp by this command
rclone --config /tmp/sftp-rcloneconfig.conf copyurl https://ash-speed.hetzner.com/10GB.bin sftpserver:/suhora-test/vikas -P

# copy url to s3 by this command
rclone --config /tmp/s3-rcloneconfig.conf copyurl https://ash-speed.hetzner.com/10GB.bin s3bucket:suhora-test/vikas -P

# test if rclone is installed for extra features
rclone --config /tmp/s3-rcloneconfig.conf copyurl https://ash-speed.hetzner.com/10GB.bin s3bucket:suhora-test/vikas -P --transfers=2 --s3-upload-concurrency=64 --s3-chunk-size=100M
