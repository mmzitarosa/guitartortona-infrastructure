#!/bin/bash
set -e

source ~/guitar-credentials.env

echo "🗄️  Initializing MariaDB databases and users..."

kubectl exec -it mariadb-0 -n databases -- mariadb -u root -p"$MARIADB_ROOT_PASSWORD" << EOF
-- Production Database
CREATE DATABASE IF NOT EXISTS guitartortona
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Staging Database
CREATE DATABASE IF NOT EXISTS guitartortona_staging
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Production User
CREATE USER IF NOT EXISTS 'guitartortona'@'%' IDENTIFIED BY '$MARIADB_PRODUCTION_PASSWORD';
GRANT ALL PRIVILEGES ON guitartortona.* TO 'guitartortona'@'%';

-- Staging User
CREATE USER IF NOT EXISTS 'guitartortona_staging'@'%' IDENTIFIED BY '$MARIADB_STAGING_PASSWORD';
GRANT ALL PRIVILEGES ON guitartortona_staging.* TO 'guitartortona_staging'@'%';

FLUSH PRIVILEGES;

-- Verification
SHOW DATABASES;
SELECT User, Host FROM mysql.user WHERE User LIKE 'guitar%';
EOF

echo "✅ Databases and users created successfully"