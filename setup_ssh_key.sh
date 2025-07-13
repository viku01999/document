# SSH Key Setup on Ubuntu — Step-by-Step Guide with Examples

# Step 1: Remove old SSH keys and directory (if any)
rm -rf ~/.ssh
# What this does:
# Deletes your current SSH directory and all existing keys inside.
# No output means success.

# Step 2: Create a new `.ssh` directory with secure permissions
mkdir ~/.ssh
chmod 700 ~/.ssh
ls -ld ~/.ssh
# Expected output:
# drwx------ 2 youruser youruser 4096 Jul 14 10:00 /home/youruser/.ssh
# Explanation:
# Creates `.ssh` folder and sets permissions so only your user can access it.

# Step 3: Generate a new ED25519 SSH key with your email
ssh-keygen -t ed25519 -C "viku01999@gmail.com" -f ~/.ssh/id_ed25519 -N ""
# Example output:
# Generating public/private ed25519 key pair.
# Your identification has been saved in /home/youruser/.ssh/id_ed25519
# Your public key has been saved in /home/youruser/.ssh/id_ed25519.pub
# The key fingerprint is:
# SHA256:abc123... viku01999@gmail.com
# The key's randomart image is:
# +--[ED25519 256]--+
# |    ..           |
# |   .o .          |
# |  ooo o          |
# |  +. o .         |
# | . E . + S       |
# |  o o . =        |
# |   . o +         |
# |    + .          |
# |                 |
# +----[SHA256]-----+
# Explanation:
# Generates a new SSH keypair with no passphrase (-N ""), labeled with your email.

# Step 4: Start the ssh-agent to manage your keys
eval "$(ssh-agent -s)"
# Example output:
# Agent pid 12345
# Explanation:
# Starts the ssh-agent program in the background to handle SSH key authentication.

# Step 5: Add your new SSH private key to the ssh-agent
ssh-add ~/.ssh/id_ed25519
# Example output:
# Identity added: /home/youruser/.ssh/id_ed25519 (viku01999@gmail.com)
# Explanation:
# Registers your private key with ssh-agent so it can be used for SSH authentication.

# Step 6: Copy your public SSH key for GitHub
cat ~/.ssh/id_ed25519.pub
# Example output:
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG...rest_of_key... viku01999@gmail.com
# Action:
# Select and copy the entire output line above.

# Step 7: Add your SSH public key to your GitHub account
# 1. Go to: https://github.com/settings/keys
# 2. Click "New SSH key"
# 3. Set a Title (e.g., "Ubuntu Laptop July 2025")
# 4. Paste your copied public key into the Key field
# 5. Click "Add SSH key"

# Step 8: Test your SSH connection to GitHub
ssh -T git@github.com
# Expected output:
# Hi viku01999! You've successfully authenticated, but GitHub does not provide shell access.
# Explanation:
# This confirms your SSH key is working and GitHub recognizes you.

# Summary:
# - You safely removed old keys.
# - Created new SSH key pair.
# - Added the new key to ssh-agent.
# - Uploaded public key to GitHub.
# - Tested SSH connection successfully.
