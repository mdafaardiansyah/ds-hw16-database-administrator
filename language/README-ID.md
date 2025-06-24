# MySQL Database Configuration - DigitalSkola Homework 16

<!-- Language Toggle -->
**🌐 Language / Bahasa:**
- [🇺🇸 English](../README.md#english-version)
- [🇮🇩 Bahasa Indonesia](#bahasa-indonesia)

---

## Bahasa Indonesia

Proyek ini mengimplementasikan konfigurasi database MySQL menggunakan Docker Compose untuk memenuhi tugas **DigitalSkola Homework ke 16 - Database Administrator**. Sistem ini menyediakan lingkungan database yang reproducible dan terisolasi dengan multiple databases, users, dan privilege management.

## 📋 Requirements

Sebelum memulai, pastikan sistem Anda memiliki:

- Docker Engine (versi 20.10 atau lebih baru)
- Docker Compose (versi 2.0 atau lebih baru)
- Git (untuk cloning repository)
- Terminal/Command Line access

### Verifikasi Prerequisites

```bash
# Cek versi Docker
docker --version

# Cek versi Docker Compose
docker compose version

# Cek status Docker service
sudo systemctl status docker
```

## 🏗️ Struktur Proyek

```
homework-16/
├── docker-compose.yml      # Konfigurasi Docker Compose
├── init/
│   └── init-db.sh          # Script inisialisasi database
├── cleanup.sh              # Script untuk cleanup
├── verify.sh               # Script verifikasi
├── language/
│   └── README-ID.md        # Dokumentasi Bahasa Indonesia
└── README.md               # Dokumentasi ini
 
```

## 🚀 Quick Start

### 1. Clone dan Masuk ke Direktori Proyek

```bash
git clone https://github.com/dafafrancis/digitalskola-homework-16.git

cd digitalskola-homework-16
```

### 2. Berikan Permission Execute pada Scripts

```bash
chmod +x init/init-db.sh
chmod +x cleanup.sh
chmod +x verify.sh
```

### 3. Jalankan MySQL Container

```bash
docker compose up -d
```

**Note**: MySQL akan berjalan di port 3307 (bukan 3306 default) untuk menghindari konflik dengan MySQL yang mungkin sudah terinstall di sistem.

Perintah ini akan:
- Download MySQL 8.0 image (jika belum ada)
- Membuat dan menjalankan container MySQL
- Menjalankan script inisialisasi secara otomatis
- Membuat databases dan users sesuai requirement

### 4. Verifikasi Installation

```bash
./verify.sh
```

## 📊 Spesifikasi Database

### Databases yang Dibuat

| Database Name | Purpose |
|---------------|----------|
| `Databaseservicea` | Database untuk service A |
| `Databaseserviceb` | Database untuk service B |
| `databaseservicec` | Database untuk service C |

### Users dan Privileges

| Username | Password | Privileges | Target Database |
|----------|----------|------------|----------------|
| `andi` | `password_andi` | SELECT, INSERT, UPDATE, DELETE | `Databaseservicea` |
| `dion` | `password_dion` | SELECT (read-only) | `Databaseserviceb` |
| `eka` | `password_eka` | ALL PRIVILEGES | All databases |
| `root` | `root_password_rahasia` | ALL PRIVILEGES | All databases |

## 🔧 Penggunaan Detail

### Menjalankan Container

```bash
# Jalankan di background
docker compose up -d

# Cek status container
docker compose ps
```

### Akses Database

**Port**: MySQL berjalan di port **3307** (bukan 3306 default)

#### 1. Akses sebagai Root

```bash
docker compose exec mysql-db mysql -u root -p'root_password_rahasia'
```

#### 2. Akses sebagai User Andi

```bash
docker compose exec mysql-db mysql -u andi -p'password_andi'
```

#### 3. Akses sebagai User Dion

```bash
docker compose exec mysql-db mysql -u dion -p'password_dion'
```

#### 4. Akses sebagai User Eka

```bash
docker compose exec mysql-db mysql -u eka -p'password_eka'
```

### Testing Privileges

#### Test User Andi (CRUD pada Databaseservicea)
```bash
# Lihat previleges yang dimiliki user Andi
SHOW GRANTS FOR 'andi'@'%';
```

#### Test User Dion (Read-only pada Databaseserviceb)
```bash
# Lihat previleges yang dimiliki user Dion
SHOW GRANTS FOR 'dion'@'%';
```

#### Test User Eka (Full privileges)
```bash
# Lihat previleges yang dimiliki user Eka
SHOW GRANTS FOR 'eka'@'%';
```

## 🔍 Monitoring dan Troubleshooting

### Melihat Logs Container

```bash
# Lihat logs real-time
docker compose logs -f mysql-db

# Lihat logs terakhir
docker compose logs --tail=50 mysql-db
```

### Cek Status Container

```bash
# Status semua services
docker compose ps

# Detail container
docker inspect mysql-homework16
```

### Restart Container

```bash
# Restart service
docker compose restart mysql-db

# Stop dan start ulang
docker compose down
docker compose up -d
```

### Backup Database

```bash
# Backup single database
docker compose exec mysql-db mysqldump -u root -p'root_password_rahasia' Databaseservicea > backup_servicea.sql

# Backup all databases
docker compose exec mysql-db mysqldump -u root -p'root_password_rahasia' --all-databases > backup_all.sql
```

### Restore Database

```bash
# Restore dari backup
docker compose exec -T mysql-db mysql -u root -p'root_password_rahasia' Databaseservicea < backup_servicea.sql
```

## 🧹 Cleanup

### Cleanup Otomatis

```bash
./cleanup.sh
```

Script ini akan:
- Menghentikan semua container
- Menghapus volumes (data akan hilang)
- Membersihkan networks yang tidak terpakai
- Opsional: menghapus MySQL images

### Cleanup Manual

```bash
# Stop dan hapus containers
docker compose down

# Stop, hapus containers dan volumes
docker compose down -v

# Hapus images (opsional)
docker rmi mysql:8.0

# Cleanup system
docker system prune -f
```

### Mengganti Password (Production)

```bash
# Edit docker-compose.yml
MYSQL_ROOT_PASSWORD: your_secure_password

# Update user passwords
docker compose exec mysql-db mysql -u root -p
ALTER USER 'andi'@'%' IDENTIFIED BY 'new_secure_password';
FLUSH PRIVILEGES;
```

## 📝 Verifikasi Requirements

| Requirement ID | Description | Status |
|----------------|-------------|--------|
| F-01 | MySQL instance running | ✅ |
| F-02 | Three databases created | ✅ |
| F-03 | Three users created | ✅ |
| F-04 | Andi CRUD access to Databaseservicea | ✅ |
| F-05 | Dion read-only access to Databaseserviceb | ✅ |
| F-06 | Eka full admin privileges | ✅ |

## 📚 Referensi

- [MySQL Official Documentation](https://dev.mysql.com/doc/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Docker Image](https://hub.docker.com/_/mysql)

## 👥 Support

Jika mengalami masalah:

1. Cek logs container: `docker compose logs mysql-db`
2. Jalankan script verifikasi: `./verify.sh`
3. Restart container: `docker compose restart mysql-db`
4. Cleanup dan start fresh: `./cleanup.sh && docker compose up -d`

---

**Created for / Dibuat untuk**: Digital Skola DevOps Homework 16  
**Date / Tanggal**: June 24, 2025 / 24 Juni 2025  
**Version / Versi**: 1.0

---

### 🔗 Quick Navigation / Navigasi Cepat

- [🇺🇸 English Version](../README.md#english-version)
- [🇮🇩 Bahasa Indonesia](#bahasa-indonesia)
- [📋 Requirements](#requirements)
- [🚀 Quick Start](#quick-start)
- [📊 Spesifikasi Database](#spesifikasi-database)
- [🔧 Penggunaan Detail](#penggunaan-detail)
- [🧹 Cleanup](#cleanup)