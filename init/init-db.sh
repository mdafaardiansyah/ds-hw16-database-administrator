#!/bin/bash
# Shebang: Menandakan file ini adalah script bash
set -e # Jika ada perintah gagal, script akan langsung berhenti

echo "Starting database initialization..." # Menampilkan pesan mulai inisialisasi

# Tunggu hingga MySQL siap menerima koneksi
until mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
  echo "Waiting for MySQL to be ready..." # Pesan menunggu MySQL
  sleep 2 # Tunggu 2 detik sebelum cek lagi
 done

echo "MySQL is ready. Creating databases and users..." # Pesan jika MySQL sudah siap

# Menjalankan perintah SQL berikut sebagai root
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    -- Membuat database jika belum ada
    CREATE DATABASE IF NOT EXISTS Databaseservicea;
    CREATE DATABASE IF NOT EXISTS Databaseserviceb;
    CREATE DATABASE IF NOT EXISTS databaseservicec;
    
    -- Membuat user jika belum ada
    CREATE USER IF NOT EXISTS 'andi'@'%' IDENTIFIED BY 'password_andi';
    CREATE USER IF NOT EXISTS 'dion'@'%' IDENTIFIED BY 'password_dion';
    CREATE USER IF NOT EXISTS 'eka'@'%' IDENTIFIED BY 'password_eka';
    
    -- Memberikan hak akses ke user andi (SELECT, INSERT, UPDATE, DELETE, CREATE, DROP pada Databaseservicea)
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP ON Databaseservicea.* TO 'andi'@'%';
    
    -- Memberikan hak akses ke user dion (hanya SELECT pada Databaseserviceb)
    GRANT SELECT ON Databaseserviceb.* TO 'dion'@'%';
    
    -- Memberikan semua hak akses ke user eka pada semua database
    GRANT ALL PRIVILEGES ON *.* TO 'eka'@'%' WITH GRANT OPTION;
    
    -- Menyegarkan hak akses agar perubahan berlaku
    FLUSH PRIVILEGES;
    
    -- Menampilkan database yang sudah dibuat
    SHOW DATABASES;
    
    -- Menampilkan user yang sudah dibuat
    SELECT user, host FROM mysql.user WHERE user IN ('andi', 'dion', 'eka');
EOSQL

echo "Database initialization completed successfully!" # Pesan jika inisialisasi selesai
echo "Created databases: Databaseservicea, Databaseserviceb, databaseservicec" # Info database yang dibuat
echo "Created users: andi, dion, eka with respective privileges" # Info user yang dibuat