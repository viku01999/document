# 🚀 README: Install and Configure Keycloak 26.2.5 with PostgreSQL on Ubuntu

---

## 🔍 Overview

This guide will help you install **Keycloak 26.2.5** on Ubuntu, configure it with PostgreSQL, and run it with necessary environment variables.

---

## ✅ Prerequisites

- 🖥️ Ubuntu server with sudo privileges  
- ☕ Java 21 installed  
- 🐘 PostgreSQL installed and running  
- 💻 Basic Linux terminal knowledge  

---

## 🛠️ Setup Steps

```bash
# Step 1️⃣: Download and extract Keycloak
cd /opt
sudo wget https://github.com/keycloak/keycloak/releases/download/26.2.5/keycloak-26.2.5.zip
sudo unzip keycloak-26.2.5.zip -d /opt
sudo mv /opt/keycloak-26.2.5 /opt/keycloak

# Step 2️⃣: Setup PostgreSQL database and user
sudo -u postgres psql <<EOF
DROP DATABASE IF EXISTS keycloak;
DROP USER IF EXISTS keycloak;

CREATE USER keycloak WITH PASSWORD 'kcpassword';
CREATE DATABASE keycloak OWNER keycloak;
\c keycloak
ALTER SCHEMA public OWNER TO keycloak;
GRANT ALL ON SCHEMA public TO keycloak;
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;
EOF

# Step 3️⃣: Export environment variables
export KC_DB=postgres
export KC_DB_URL=jdbc:postgresql://localhost/keycloak
export KC_DB_USERNAME=keycloak
export KC_DB_PASSWORD=kcpassword
export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin

# Step 4️⃣: Create Keycloak startup script
cat <<'EOT' | sudo tee /opt/keycloak/start-keycloak.sh
#!/bin/bash
export KC_DB=postgres
export KC_DB_URL=jdbc:postgresql://localhost/keycloak
export KC_DB_USERNAME=keycloak
export KC_DB_PASSWORD=kcpassword
export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin
cd /opt/keycloak
bin/kc.sh build
bin/kc.sh start-dev
EOT

sudo chmod +x /opt/keycloak/start-keycloak.sh

# Step 5️⃣: Run Keycloak
sudo /opt/keycloak/start-keycloak.sh





flowchart TD
    A[Download & Extract Keycloak] --> B[Setup PostgreSQL DB & User]
    B --> C[Export Env Variables]
    C --> D[Create Startup Script]
    D --> E[Run Keycloak]
    E --> F[Access Keycloak @ http://localhost:8080]
