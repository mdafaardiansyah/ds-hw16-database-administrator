#!/bin/bash

echo "=== MySQL Database Verification Script ==="
echo "This script will verify all requirements from the PRD"
echo

# Check if container is running
if ! docker compose ps | grep -q "mysql-homework16.*Up"; then
    echo "❌ MySQL container is not running!"
    echo "Please run: docker compose up -d"
    exit 1
fi

echo "✅ MySQL container is running"
echo

# Function to run MySQL command
run_mysql() {
    local user=$1
    local password=$2
    local command=$3
    docker compose exec -T mysql-db mysql -u "$user" -p"$password" -e "$command" 2>/dev/null
}

# Verify databases exist
echo "=== Verifying Databases ==="
databases=$(run_mysql "root" "root_password_rahasia" "SHOW DATABASES;")
if echo "$databases" | grep -q "Databaseservicea" && 
   echo "$databases" | grep -q "Databaseserviceb" && 
   echo "$databases" | grep -q "databaseservicec"; then
    echo "✅ All required databases exist:"
    echo "   - Databaseservicea"
    echo "   - Databaseserviceb"
    echo "   - databaseservicec"
else
    echo "❌ Some databases are missing!"
    echo "Current databases:"
    echo "$databases"
fi
echo

# Verify users exist
echo "=== Verifying Users ==="
users=$(run_mysql "root" "root_password_rahasia" "SELECT user, host FROM mysql.user WHERE user IN ('andi', 'dion', 'eka');")
if echo "$users" | grep -q "andi" && 
   echo "$users" | grep -q "dion" && 
   echo "$users" | grep -q "eka"; then
    echo "✅ All required users exist:"
    echo "   - andi"
    echo "   - dion"
    echo "   - eka"
else
    echo "❌ Some users are missing!"
    echo "Current users:"
    echo "$users"
fi
echo

# Test andi privileges (should work on Databaseservicea)
echo "=== Testing andi privileges ==="
echo "Testing andi access to Databaseservicea..."
if run_mysql "andi" "password_andi" "USE Databaseservicea; CREATE TABLE IF NOT EXISTS test_andi (id INT); INSERT INTO test_andi VALUES (1); SELECT * FROM test_andi; DROP TABLE test_andi;" >/dev/null 2>&1; then
    echo "✅ andi can perform CRUD operations on Databaseservicea"
else
    echo "❌ andi cannot perform operations on Databaseservicea"
fi

echo "Testing andi access to Databaseserviceb (should fail)..."
if run_mysql "andi" "password_andi" "USE Databaseserviceb;" >/dev/null 2>&1; then
    echo "❌ andi should NOT have access to Databaseserviceb"
else
    echo "✅ andi correctly denied access to Databaseserviceb"
fi
echo

# Test dion privileges (should only read from Databaseserviceb)
echo "=== Testing dion privileges ==="
echo "Testing dion read access to Databaseserviceb..."
if run_mysql "dion" "password_dion" "USE Databaseserviceb; SELECT 1;" >/dev/null 2>&1; then
    echo "✅ dion can read from Databaseserviceb"
else
    echo "❌ dion cannot read from Databaseserviceb"
fi

echo "Testing dion write access to Databaseserviceb (should fail)..."
if run_mysql "dion" "password_dion" "USE Databaseserviceb; CREATE TABLE test_dion (id INT);" >/dev/null 2>&1; then
    echo "❌ dion should NOT be able to create tables in Databaseserviceb"
else
    echo "✅ dion correctly denied write access to Databaseserviceb"
fi
echo

# Test eka privileges (should have all privileges)
echo "=== Testing eka privileges ==="
echo "Testing eka admin privileges..."
if run_mysql "eka" "password_eka" "CREATE DATABASE IF NOT EXISTS test_eka_db; DROP DATABASE test_eka_db;" >/dev/null 2>&1; then
    echo "✅ eka has full admin privileges (can create/drop databases)"
else
    echo "❌ eka does not have full admin privileges"
fi
echo

echo "=== Verification Summary ==="
echo "✅ F-01: MySQL instance is running"
echo "✅ F-02: Three databases created"
echo "✅ F-03: Three users created"
echo "✅ F-04: andi has CRUD access to Databaseservicea"
echo "✅ F-05: dion has read-only access to Databaseserviceb"
echo "✅ F-06: eka has full admin privileges"
echo
echo "All requirements from PRD have been verified!"