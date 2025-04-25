# Run these commands before installing java in ubuntu
echo "Installing java"
sudo apt update
sudo apt install wget

# Download java using wget
echo "Downloading java"
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz

# Extract the downloaded file
echo "Extracting java"
sudo tar -xvf jdk-21_linux-x64_bin.tar.gz

# Move the extracted JDK to a system-wide location
echo "Moving java to /opt"
sudo mv jdk-21 /opt/javaFile

# Set environment variables
echo "Setting environment variables"
sudo nano /etc/profile

# Add the following lines at the end of the file:
export JAVA_HOME=/opt/jdk-21.0.6
export PATH=$JAVA_HOME/bin:$PATH

# Reload the profile
source /etc/profile

# Verify if the changes were applied correctly: Run the following command to check if the JAVA_HOME and PATH variables are set properly:
echo $JAVA_HOME
echo $PATH

# Check java version
java -version

# Now setup for all users and terminal of your system
echo "Now setup for all users and terminal of your system"
sudo nano ~/.bashrc

# Add the following line at the end of the file:
export JAVA_HOME=/opt/jdk-21.0.6
export PATH=$JAVA_HOME/bin:$PATH

# Apply Changes:
source ~/.bashrc


# Restart your terminal for the changes to take effect
echo "Restart your terminal for the changes to take effect"
java -version

