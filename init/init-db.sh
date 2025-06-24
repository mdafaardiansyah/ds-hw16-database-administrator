#!/bin/bash
set -e

echo "Starting database initialization..."

# Wait for MySQL to be ready
until mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
  echo "Waiting for MySQL to be ready..."
  sleep 2
done

echo "MySQL is ready. Creating databases and users..."

# Execute SQL commands
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    -- Create databases
    CREATE DATABASE IF NOT EXISTS Databaseservicea;
    CREATE DATABASE IF NOT EXISTS Databaseserviceb;
    CREATE DATABASE IF NOT EXISTS databaseservicec;
    
    -- Create users
    CREATE USER IF NOT EXISTS 'andi'@'%' IDENTIFIED BY 'password_andi';
    CREATE USER IF NOT EXISTS 'dion'@'%' IDENTIFIED BY 'password_dion';
    CREATE USER IF NOT EXISTS 'eka'@'%' IDENTIFIED BY 'password_eka';
    
    -- Grant privileges for andi (SELECT, INSERT, UPDATE, DELETE, CREATE, DROP on Databaseservicea)
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP ON Databaseservicea.* TO 'andi'@'%';
    
    -- Grant privileges for dion (SELECT only on Databaseserviceb)
    GRANT SELECT ON Databaseserviceb.* TO 'dion'@'%';
    
    -- Grant privileges for eka (ALL PRIVILEGES on all databases)
    GRANT ALL PRIVILEGES ON *.* TO 'eka'@'%' WITH GRANT OPTION;
    
    -- Flush privileges to ensure changes take effect
    FLUSH PRIVILEGES;
    
    -- Show created databases
    SHOW DATABASES;
    
    -- Show created users
    SELECT user, host FROM mysql.user WHERE user IN ('andi', 'dion', 'eka');
EOSQL

echo "Database initialization completed successfully!"
echo "Created databases: Databaseservicea, Databaseserviceb, databaseservicec"
echo "Created users: andi, dion, eka with respective privileges"